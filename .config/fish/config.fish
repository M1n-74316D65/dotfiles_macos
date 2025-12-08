if status is-interactive
    set -U fish_greeting ""

    # Ghostty shell integration
    if set -q GHOSTTY_RESOURCES_DIR
        set -l ghostty_fish "$GHOSTTY_RESOURCES_DIR/shell-integration/fish/vendor_conf.d/ghostty-shell-integration.fish"
        test -f $ghostty_fish; and source $ghostty_fish
    end

    # Environment variables
    set -gx EDITOR nvim
    set -gx VISUAL nvim
    set -gx CHARM_HOST "192.168.1.139"
    set -gx TERM_PROGRAM ghostty

    # PATH setup (prepend in reverse priority order)
    fish_add_path -gP "$HOME/.local/bin"
    fish_add_path -gP "$HOME/go/bin"
    fish_add_path -gP "$HOME/.config/herd-lite/bin"
    fish_add_path -gP "$HOME/.bun/bin"
    fish_add_path -gP /opt/homebrew/bin

    # macOS SSH agent (using default macOS keychain)
    set -l onepassword_sock "$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
    test -S $onepassword_sock; and set -gx SSH_AUTH_SOCK $onepassword_sock

    # Tool initialization (with existence checks)
    type -q starship; and starship init fish | source
    type -q zoxide; and zoxide init fish | source
    type -q atuin; and atuin init fish | source
    type -q direnv; and direnv hook fish | source

    # NVM setup (lazy load for performance)
    set -gx NVM_DIR "$HOME/.nvm"
    function __nvm
        test -s "$NVM_DIR/nvm.sh"; or return 1
        type -q bass; or return 1
        bass source "$NVM_DIR/nvm.sh" --no-use ';' nvm $argv
    end

    function nvm
        __nvm $argv
    end

    __nvm use lts >/dev/null 2>/dev/null

    # Source custom modules
    test -f ~/.config/fish/my_modules/pastes.fish; and source ~/.config/fish/my_modules/pastes.fish

    # SSH aliases
    alias server="ssh root@192.168.1.139"
    alias pico="ssh pico.sh"
    alias texto="ssh texto-plano.xyz"
    alias xinu="ssh m1n@xinu.me"
    alias uber="ssh min@belinda.uberspace.de"

    # Editor aliases
    alias vi=nvim
    alias vim=nvim

    # Development aliases
    alias explain="gh copilot explain"
    alias suggest="gh copilot suggest"
    alias jj-push="jj git push -c @-"
    alias pa="hut paste"

    # macOS package management
    alias update="brew update && brew upgrade"
    alias cleanup="brew cleanup && brew autoremove"

    # Application aliases
    alias cls=clear
    alias radio="clear; mpv https://radio.m1n.land --volume=60"
    alias note=dnote

    # Fish config
    alias fishconfig="nvim ~/.config/fish/config.fish"
    alias fishreload="source ~/.config/fish/config.fish"

    # macOS specific
    alias showfiles="defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder"
    alias hidefiles="defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder"
    alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"
    alias upgrade=update

    # Custom functions
    function ytdlp-bandcamp
        yt-dlp -o "%(artist)s/%(album)s/%(title)s.%(ext)s" $argv
    end

    function brew-remove
        brew uninstall --zap $argv
    end

    function cdtmp
        set tmpdir (mktemp -d -t cdtmp)
        cd $tmpdir
        echo "Created temporary directory: $tmpdir"
    end

    function mkcd
        mkdir -p $argv[1]; and cd $argv[1]
    end

    if not set -q SSH_AUTH_SOCK; and not pgrep -x ssh-agent >/dev/null
        eval (ssh-agent -c)
    end
end
