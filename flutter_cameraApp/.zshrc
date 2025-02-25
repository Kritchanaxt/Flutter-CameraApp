export ANDROID_SDK_ROOT=/path/to/your/android/sdk
export PATH=$PATH:$ANDROID_SDK_ROOT/build-tools/your-build-tools-version


# Flutter
export PATH=$HOME/Development/flutter/bin:$PATH

# Kotlin
export PATH="$PATH:/path/to/kotlin/bin"

# SDKMAN setup - ต้องอยู่ก่อนส่วนที่ใช้งาน SDKMAN
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$SDKMAN_DIR/bin/sdkman-init.sh" ]] && source "$SDKMAN_DIR/bin/sdkman-init.sh"

# Ruby
export PATH="/usr/local/opt/ruby/bin:/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/path/to/gem/bin:/usr/local/lib/ruby/gems/3.x.x/bin:$PATH"

# Homebrew
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"

# RVM - ควรอยู่ท้ายสุดของ PATH
export PATH="$PATH:$HOME/.rvm/bin"

# Alias for Python3
alias python="python3"

# MongoDB
export PATH="$PATH:/Users/kritchanaxt_/Downloads/mongodb-macos-aarch64-8.0.3/bin"
export JAVA_HOME=$(/usr/libexec/java_home)
export PATH="$HOME/Development/flutter/bin:$PATH"
export PATH="$HOME/Development/flutter/bin:$PATH"
export JAVA_HOME="$(/usr/libexec/java_home -v 17)"
export GRADLE_OPTS="-Dorg.gradle.java.home=$( /usr/libexec/java_home -v 17 )"
