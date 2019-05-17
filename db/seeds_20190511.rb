# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Category.create!([
  {name: "JavaScript"},
  {name: "Rails"},
  {name: "jQuery}
]
  )

User.create!(
  {name: "aaa",
   email: "aaa@yahoo.co.jp",
   password_digest: "$2a$10$hJ4e.70zupqDBZzGv4CB6OGwN/LHWsAsRu/nJREVZ68zOhSmVfafq",
   remember_digest: nil,
   activation_digest: "$2a$10$HyJcAGmtsV8H4kuFACiy7uFtNXNjNxyU4N7eu9MRFvEB7Y5dklb.u",
   activated: false,
   activated_at: nil,
   admin: false}
)

Micropost.create!([
  {content: "ランダムな値を生成します",
 user_id: 1,
 code: "\r\n<!DOCTYPE html>\r\n<head>\r\n<style>\r\nbody {\r\n  background: gray;\r\n}\r\n#spin {\r\n  cursor: pointer;\r\n  width: 100px;\r\n  background: #3498db;\r\n  border-radius: 17px;\r\n  color: #fff;\r\n  text-align: center;\r\n}\r\n\r\n</style>\r\n</head>\r\n<body>\r\n  <div class=\"pan\"><input value=\"1\"></div>\r\n  <div class=\"pan\"><input value=\"2\"></div>\r\n  <div class=\"pan\"><input value=\"3\"></div>\r\n  <div class=\"pan\"><input value=\"4\"></div>\r\n  <div class=\"pan\"><input value=\"5\"></div>\r\n  <div id=\"spin\";  border=\"5px\">start</div>\r\n  <script>\r\n  (function() {\r\n\t'use strict';\r\n\r\n\tvar pans = document.getElementsByClassName('pan');\r\n\tvar spin = document.getElementById('spin');\r\n\r\n\tfunction runSlot(n) {\r\n\t  setTimeout(function() {\r\n\t    pans[n].children[0].value = 1 + Math.floor(Math.random()*5);\r\n\t    runSlot(n);\t\r\n\t  },
50);\r\n\t}\r\n\r\n\tspin.addEventListener('click',
 function() {\r\n\tvar i;\r\n\tfor(i=0; i< pans.length; i++){\r\n\t  runSlot(i);\r\n\t}\r\n\t});\r\n  })();\r\n  </script>\r\n</body>\r\n</html>\r\n",
 title: "ランダム値",
 category_id: 1},

 {content: "×  seed.rb
○ seeds.rb
ファイル名には気を付けましょう
コマンド上はエラーならないみたい
",
user_id: 1,
code: "",
title: "rails db:seed",
category_id: 2}
])
