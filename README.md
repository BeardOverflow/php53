# A Docker image for running old PHP 5.3 projects

https://hub.docker.com/r/beardoverflow/php53

```
cat << EOF > index.php
<?php
  phpinfo();
?>
EOF

docker run -p 80:80 -v $(pwd):/var/www beardoverflow/php53
```

Open http://localhost:80/index.php

---

Based on Debian Squeeze LTS

https://wiki.debian.org/DebianSqueeze
