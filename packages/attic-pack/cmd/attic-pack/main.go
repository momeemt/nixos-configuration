package main

import (
	"flag"
	"fmt"
	"os"
	"regexp"

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
	case "plan":
		return runPlan(args[1:])
	default:
		return usageError(fmt.Sprintf("unknown command %q", args[0]))
	}
}

func runPlan(args []string) error {
	flags := flag.NewFlagSet("plan", flag.ContinueOnError)
	flags.SetOutput(os.Stderr)

	pathSizesPath := flags.String("path-sizes", "", "input TSV file containing NAR size and store path")
	uploadPathSizesPath := flags.String("upload-path-sizes", "", "output TSV file for selected paths")
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

func writeSkippedPathSizesFile(path string, entries []plan.SkippedEntry) error {
	file, err := os.Create(path)
	if err != nil {
		return err
	}
	defer file.Close()

	return plan.WriteSkippedPathSizes(file, entries)
}

func usageError(message string) error {
	return fmt.Errorf("%s\nusage: attic-pack plan --path-sizes <file> --upload-path-sizes <file> --skipped-path-sizes <file> [--max-path-nar-bytes <bytes>] [--exclude-store-regex <regex>]", message)
}
