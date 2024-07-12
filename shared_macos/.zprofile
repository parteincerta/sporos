if [ -z "$HOMEBREW_PREFIX" ]; then
    _arch="$(uname -m)"
    if [ "$_arch" = "arm64" ]; then
        whence /opt/homebrew/bin/brew &>/dev/null &&
            export HOMEBREW_PREFIX="/opt/homebrew"
    elif [ "$_arch" = "x86_64" ]; then
        whence /usr/local/bin/brew &>/dev/null &&
            export HOMEBREW_PREFIX="/usr/local"
    fi
fi

[ -d "$ASDF_DATA_DIR/shims" ] &&
[[ ! "$PATH" = *"$ASDF_DATA_DIR/shims"* ]] &&
    export PATH="$ASDF_DATA_DIR/shims:$PATH"

[ -d "$HOMEBREW_PREFIX/opt/libpq/bin" ] &&
[[ ! "$PATH" = *"$HOMEBREW_PREFIX/opt/libpq/bin"* ]] &&
    export PATH="$HOMEBREW_PREFIX/opt/libpq/bin:$PATH"

[ -d "$HOMEBREW_PREFIX/sbin" ] &&
[[ ! "$PATH" = *"$HOMEBREW_PREFIX/sbin"* ]] &&
    export PATH="$HOMEBREW_PREFIX/sbin:$PATH"

[ -d "$HOMEBREW_PREFIX/bin" ] &&
[[ ! "$PATH" = *"$HOMEBREW_PREFIX/bin"* ]] &&
    export PATH="$HOMEBREW_PREFIX/bin:$PATH"

[ -d "$HOME/.docker/bin" ] &&
[[ ! "$PATH" = *"$$HOME/.docker/bin"* ]] &&
    export PATH="$PATH:$HOME/.docker/bin"

[ -d "$HOME/.local/bin" ] &&
[[ ! "$PATH" = *"$$HOME/.docker/bin"* ]] &&
    export PATH="$PATH:$HOME/.docker/bin"

function setup_java_environment() {
    if whence asdf &>/dev/null; then
        local JAVA_HOME="$(dirname $(asdf which java 2>/dev/null))"
        [ -d "$JAVA_HOME" ] && export JAVA_HOME="$(realpath $JAVA_HOME/..)"
    fi
}

function setup_python_environment() {
    if whence asdf &>/dev/null; then
        local PYTHON3="$(asdf which python3 2>/dev/null)"
        [ -z "$PYTHON3" ] && PYTHON3="/usr/bin/python3"

        local PYTHON3_BIN_PATH="$($PYTHON3 -c "import site; print(site.USER_BASE + '/bin')")"
        [ -d "$$PYTHON3_BIN_PATH" ] &&
        [[ ! "$PATH" = *"$PYTHON3_BIN_PATH"* ]] &&
            export PATH="$PATH:$PYTHON3_BIN_PATH"
    fi
}

setup_java_environment

# Only necessary once we use a version of Python besides the one that's
# shipped with macOS. Also saves a performance penaltiy of executing python3
# each time a new login shell is spawned.
# setup_python_environment
