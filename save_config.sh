if [ ! -f .env ]; then
  echo "warning!!! plaese make .env file and set some variables"
  exit 1
fi

source ./.env

cp -rf "$LOCALAPPDATA/nvim" .

mkdir -p home
cp -f "$MY_HOME_DIR/.vimrc" home
cp -f "$MY_HOME_DIR/.zshrc" home

mkdir -p win_local
cp -f $LOCALAPPDATA"\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json" win_local
