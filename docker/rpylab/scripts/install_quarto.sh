## Instsall Quarto

wget https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.tar.gz
tar -C /usr/local -xvzf quarto-${QUARTO_VERSION}-linux-amd64.tar.gz --strip-components=1

if [ -n "$R_HOME" ]; then
	R -q -e 'install.packages(c("quarto"))'
fi
if [ -n "$PYTHON_VER" ] ; then
	python3 -m pip install jupyterlab-quarto
fi

