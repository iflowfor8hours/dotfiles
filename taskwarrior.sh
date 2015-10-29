# Taskwarrior
taskwarrior() {
  echo "Setting up Taskwarrior"
  (mkdir -p /tmp/taskinstaller &&
  cd /tmp/taskinstaller &&
  curl -O http://taskwarrior.org/download/task-2.4.4.tar.gz &&
  tar xzvf task-2.4.4.tar.gz &&
  cd task-2.4.4 &&
  cmake -DCMAKE_BUILD_TYPE=release . &&
  make &&
  sudo make install)
  if [ $? -ne 0 ]; then
    echo "Failed to setup taskwarrior"
    return 1
  fi
}

taskwarrior
