curl -x <[protocol://][user:password@]proxyhost[:port]> url
--proxy <[protocol://][user:password@]proxyhost[:port]> url
--proxy http://user:password@Your-Ip-Here:Port url
-x http://user:password@Your-Ip-Here:Port url



curl -x socks5://127.0.0.1:1024 http://www.google.com # -x 参数等同于 --proxy

curl --proxy "socks5://127.0.0.1:1086" "https://google.com"


curl --proxy <[protocol://][user:password@]proxyhost[:port]> url
--proxy http://user:password@Your-Ip-Here:Port url
-x http://user:password@Your-Ip-Here:Port url
