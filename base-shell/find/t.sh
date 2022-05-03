#!/bin/sh


find /var/lib/docker/containers/ -name *-json.log -print0 | xargs -0 -L 1 -I file sh -c "cat /dev/null > file"
find . \( ! -regex "\.*" \) -type d -d 1


find . \( -regex "*/bin/elasticsearch" \) -type f -maxdepth 3

find ./ -type f -regex '\.\/[^/]*\/a[01][^/]*'
find ./ -type -f -regex '*\/bin\/elasticsearch$' -maxdepth 3
find ./ -type f -regex '.*a[01].*'
find ./ -type f -iregex '\.\/a[01][.].*' # 忽略小写


target_dir="./";
find . -type d -regex ".*/bin" | \
  (while read s; do
     n=$(dirname "$s")
     # cp -pr "$s" "$target_dir/${n#./}"
     echo ${n#./}
   done
  )
  
find $WORK_DIR -type d -regex ".*/elasticsearch-"$ES_VER"/bin" | \
  (while read s; do
    n=$(dirname "$s")
    echo "$WORK_DIR${n#./}"
   done
  )
## 查看硬链接
