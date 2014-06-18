Heroku+Node.js+Grunt+CoffeeScript+PhantomJS
========================

http://powerful-fortress-7920.herokuapp.com/twwc.html 

Install Dependencies
--------------------

    $ npm install -g phantomjs
    $ npm install


Run
---

    $ npm start

=> http://localhost:5000


Deploy
------

push

    $ heroku create --buildpack git://github.com/ddollar/heroku-buildpack-multi.git
    or
    $ heroku config:set BUILDPACK_URL=https://github.com/ddollar/heroku-buildpack-multi.git

    $ git push heroku master
    $ heroku open


config

    $ heroku config:add LD_LIBRARY_PATH=/usr/local/lib:/usr/lib:/lib:/app/vendor/phantomjs/lib
    $ heroku config:add PATH=/usr/local/bin:/usr/bin:/bin:/app/vendor/phantomjs/bin
    $ heroku config:add PHANTOMJS=phantomjs
    
    $ heroku config:add TWITTER_CONSUMER_KEY=aa
    $ heroku config:add TWITTER_CONSUMER_SECRET=dd
    $ heroku config:add TWITTER_ACCESS_TOKEN_KEY=dd
    $ heroku config:add TWITTER_ACCESS_TOKEN_SECRET=d

dirs
------

.fonts

    $ wget unzip ipaexg00102.zip
    $ mv ipaexg00102/ipaexg00102/ipaexg.ttf .fonts
 
  fontconfigを使う環境では追加のTTFフォントを ~/.fonts に入れておくだけで大丈夫な模様。（参考：書体関係 Wiki - unixuser200403-2 ）
  なので、日本語フォント対応するには、IPAフォントなりをダウンロードし、.fontsディレクトリを作成してTTFファイルを突っ込んだ上でherokuにpushしておけばOK。
     
WebSocket
------
 
  
PhantomJS
------

Other
-----
 なんか