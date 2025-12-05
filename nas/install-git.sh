if type git > /dev/null 2>&1; then
	echo "Already installed git" >&2;
	exit 1
fi
if [ ! -e git.spk ]; then
	curl https://packages.synocommunity.com/git/39/git.v39.f42661%5Brtd1296-rtd1619b-armada37xx%5D.spk --output git.spk
fi
sudo synopkg install git.spk
