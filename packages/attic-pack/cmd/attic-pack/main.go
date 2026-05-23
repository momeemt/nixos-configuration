package main

import (
	"flag"
	"fmt"
	"os"
	"regexp"

	"github.com/momeemt/monorepo/packages/attic-pack/internal/chunk"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/nixpathinfo"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/outpaths"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/pathinfo"
	"github.com/momeemt/monorepo/packages/attic-pack/internal/plan"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fmt.Fprintf(os.Stderr, "attic-pack: %v\n", err)
		os.Exit(1)
	}
}

func run(args []string) error {
	if len(args) == 0 {
		return usageError("missing command")
	}

	switch args[0] {
	case "chunk":
		return runChunk(args[1:])
	case "collect-json":
		return runCollectJSON(args[1:])
	case "plan":
		return runPlan(args[1:])
	case "path-sizes":
		return runPathSizes(args[1:])
	default:
		return usageError(fmt.Sprintf("unknown command %q", args[0]))
	}
}

func runChunk(args []string) error {
	flags := flag.NewFlagSet("chunk", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	uploadPathSizesPath := flags.String("upload-path-sizes", "", "input TSV file containing selected NAR size and store path")
	chunkDir := flags.String("chunk-dir", "", "output directory for chunk files")
	chunkTargetBytes := flags.Uint64("chunk-target-bytes", 0, "target total NAR size per chunk; 0 disables splitting")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if *uploadPathSizesPath == "" {
		return usageError("missing --upload-path-sizes")
	}
	if *chunkDir == "" {
		return usageError("missing --chunk-dir")
	}

	input, err := os.Open(*uploadPathSizesPath)
	if err != nil {
		return fmt.Errorf("open --upload-path-sizes: %w", err)
	}
	defer input.Close()

	entries, err := plan.ReadPathSizes(input)
	if err != nil {
		return fmt.Errorf("read --upload-path-sizes: %w", err)
	}

	chunks := chunk.Build(entries, chunk.Options{
		TargetBytes: *chunkTargetBytes,
	})

	files, err := chunk.WriteFiles(*chunkDir, chunks)
	if err != nil {
		return fmt.Errorf("write --chunk-dir: %w", err)
	}

	fmt.Printf("input_path_count=%d\n", len(entries))
	fmt.Printf("chunk_count=%d\n", len(chunks))
	for _, file := range files {
		fmt.Printf("chunk_file=%s\n", file)
	}

	return nil
}

func runCollectJSON(args []string) error {
	flags := flag.NewFlagSet("collect-json", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	outPathsPath := flags.String("out-paths", "", "input file containing nix build output paths")
	jsonDir := flags.String("json-dir", "", "output directory for path-info JSON files")
	nixBin := flags.String("nix-bin", "nix", "nix executable path")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if *outPathsPath == "" {
		return usageError("missing --out-paths")
	}
	if *jsonDir == "" {
		return usageError("missing --json-dir")
	}

	input, err := os.Open(*outPathsPath)
	if err != nil {
		return fmt.Errorf("open --out-paths: %w", err)
	}
	defer input.Close()

	paths, err := outpaths.Read(input)
	if err != nil {
		return fmt.Errorf("read --out-paths: %w", err)
	}
	if len(paths) == 0 {
		return fmt.Errorf("read --out-paths: no output paths found")
	}

	files, err := nixpathinfo.CollectJSON(paths, *jsonDir, nixpathinfo.CommandRunner(*nixBin))
	if err != nil {
		return fmt.Errorf("collect path-info JSON: %w", err)
	}

	fmt.Printf("out_path_count=%d\n", len(paths))
	fmt.Printf("path_info_json_count=%d\n", len(files))
	for _, file := range files {
		fmt.Printf("path_info_json=%s\n", file)
	}

	return nil
}

func runPathSizes(args []string) error {
	flags := flag.NewFlagSet("path-sizes", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	var pathInfoJSONPaths stringList
	flags.Var(&pathInfoJSONPaths, "path-info-json", "input JSON file from nix path-info --recursive --json; may be repeated")
	pathSizesPath := flags.String("path-sizes", "", "output TSV file containing NAR size and store path")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if len(pathInfoJSONPaths) == 0 {
		return usageError("missing --path-info-json")
	}
	if *pathSizesPath == "" {
		return usageError("missing --path-sizes")
	}

	var entries []plan.Entry
	for _, jsonPath := range pathInfoJSONPaths {
		input, err := os.Open(jsonPath)
		if err != nil {
			return fmt.Errorf("open --path-info-json %q: %w", jsonPath, err)
		}

		jsonEntries, err := pathinfo.Read(input)
		closeErr := input.Close()
		if err != nil {
			return fmt.Errorf("read --path-info-json %q: %w", jsonPath, err)
		}
		if closeErr != nil {
			return fmt.Errorf("close --path-info-json %q: %w", jsonPath, closeErr)
		}

		entries = append(entries, jsonEntries...)
	}

	entries = pathinfo.Normalize(entries)
	if err := writePathSizesFile(*pathSizesPath, entries); err != nil {
		return fmt.Errorf("write --path-sizes: %w", err)
	}

	fmt.Printf("path_info_json_count=%d\n", len(pathInfoJSONPaths))
	fmt.Printf("path_size_count=%d\n", len(entries))

	return nil
}

func runPlan(args []string) error {
	flags := flag.NewFlagSet("plan", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	pathSizesPath := flags.String("path-sizes", "", "input TSV file containing NAR size and store path")
	uploadPathSizesPath := flags.String("upload-path-sizes", "", "output TSV file for selected paths")
	uploadPathsPath := flags.String("upload-paths", "", "optional output file for selected store paths")
	skippedPathSizesPath := flags.String("skipped-path-sizes", "", "output TSV file for skipped paths")
	maxPathNARBytes := flags.Uint64("max-path-nar-bytes", 0, "skip paths with NAR size above this value; 0 disables the limit")
	excludeStoreRegex := flags.String("exclude-store-regex", "", "skip store paths matching this regular expression")

	if err := flags.Parse(args); err != nil {
		return err
	}
	if flags.NArg() != 0 {
		return usageError(fmt.Sprintf("unexpected argument %q", flags.Arg(0)))
	}
	if *pathSizesPath == "" {
		return usageError("missing --path-sizes")
	}
	if *uploadPathSizesPath == "" {
		return usageError("missing --upload-path-sizes")
	}
	if *skippedPathSizesPath == "" {
		return usageError("missing --skipped-path-sizes")
	}

	var exclude *regexp.Regexp
	if *excludeStoreRegex != "" {
		compiled, err := regexp.Compile(*excludeStoreRegex)
		if err != nil {
			return fmt.Errorf("compile --exclude-store-regex: %w", err)
		}
		exclude = compiled
	}

	input, err := os.Open(*pathSizesPath)
	if err != nil {
		return fmt.Errorf("open --path-sizes: %w", err)
	}
	defer input.Close()

	entries, err := plan.ReadPathSizes(input)
	if err != nil {
		return fmt.Errorf("read --path-sizes: %w", err)
	}

	result := plan.Build(entries, plan.Options{
		MaxPathNARBytes: *maxPathNARBytes,
		ExcludeStore:    exclude,
	})

	if err := writePathSizesFile(*uploadPathSizesPath, result.Upload); err != nil {
		return fmt.Errorf("write --upload-path-sizes: %w", err)
	}
	if *uploadPathsPath != "" {
		if err := writePathsFile(*uploadPathsPath, result.Upload); err != nil {
			return fmt.Errorf("write --upload-paths: %w", err)
		}
	}
	if err := writeSkippedPathSizesFile(*skippedPathSizesPath, result.Skipped); err != nil {
		return fmt.Errorf("write --skipped-path-sizes: %w", err)
	}

	fmt.Printf("input_path_count=%d\n", len(entries))
	fmt.Printf("upload_path_count=%d\n", len(result.Upload))
	fmt.Printf("skipped_path_count=%d\n", len(result.Skipped))

	return nil
}

func writePathSizesFile(path string, entries []plan.Entry) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	return plan.WritePathSizes(file, entries)
}

func writePathsFile(path string, entries []plan.Entry) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	return plan.WritePaths(file, entries)
}

func writeSkippedPathSizesFile(path string, entries []plan.SkippedEntry) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	return plan.WriteSkippedPathSizes(file, entries)
}

func usageError(message string) error {
	return fmt.Errorf("%s\nusage:\n  attic-pack collect-json --out-paths <file> --json-dir <dir> [--nix-bin <path>]\n  attic-pack path-sizes --path-info-json <file> [--path-info-json <file> ...] --path-sizes <file>\n  attic-pack plan --path-sizes <file> --upload-path-sizes <file> --skipped-path-sizes <file> [--upload-paths <file>] [--max-path-nar-bytes <bytes>] [--exclude-store-regex <regex>]\n  attic-pack chunk --upload-path-sizes <file> --chunk-dir <dir> [--chunk-target-bytes <bytes>]", message)
}

type stringList []string

func (values *stringList) Set(value string) error {
	*values = append(*values, value)
	return nil
}

func (values *stringList) String() string {
	return fmt.Sprint([]string(*values))
}
