# TodoTutorial

このリポジトリは[Phoenix入門 API構築からLiveViewまで](https://booth.pm/ja/items/1574315) (著者、[koga1020](https://github.com/koga1020)さん)の３章までを  
実際に辿り実装したPhoenixプロジェクトです。  

## 本で書かれている内容との差異

私はdockerでの動作確認をした際にLiveViewを動作させることができませんでした。  
原因はLiveViewの開発が進み仕様が変わったためでした。

動作確認の結果、執筆時より以下の点が変更されていることが分かりました。

- handle_eventの仕様変更
- sessionの使用とCSRF対策のコードの追加を求められる

※私が動作確認を行ったLiveViewは [08bf17184ec6bbc7020b5dfa01a79befdc506f85](https://github.com/phoenixframework/phoenix_live_view/commit/08bf17184ec6bbc7020b5dfa01a79befdc506f85) です。

### handle_eventの仕様変更について

[elixirフォーラム](https://elixirforum.com/t/phx-vale-gives-ecto-query-casterror/26372)でほぼ同じコードで現象について質問があり、  
対応方法を含め回答されています。

対応は以下のようになります。
~~~elixir
  # lib/to_tutorial_web/live/task_live.ex
  # id引数を%{"id" => id}でマッチするように対応
  def handle_event("toggle_is_finished", %{"id" => id}, socket) do
    task = Todo.get_task!(id)
    Todo.update_task(task, %{is_finished: !task.is_finished})
    {:noreply, assign(socket, tasks: Todo.list_tasks())}
  end
~~~

### sessionの使用とCSRF対策

対応コミット [08bf17184ec6bbc7020b5dfa01a79befdc506f85](https://github.com/phoenixframework/phoenix_live_view/commit/08bf17184ec6bbc7020b5dfa01a79befdc506f85) の  
CHANGELOG.mdの変更内容を一つずつ実施するだけです。

~~~elixir
# lib/to_tutorial_web/endpoint.ex
defmodule TodoTutorialWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :todo_tutorial

  @session_options [store: :cookie, key: "_todo_tutorial_key", signing_salt: "iL6yyDAu"]
  socket "/live", Phoenix.LiveView.Socket, websocket: [connect_info: [session: @session_options]]

  # ...
  # ...
  # ...

  # The session will be stored in the cookie and signed,
  # this means its contents can be read but not tampered with.
  # Set :encryption_salt if you would also like to encrypt it.
  plug Plug.Session, @session_options

  plug TodoTutorialWeb.Router
end
~~~

~~~
# lib/todo_tutorial_web/templates/layout/app.html.eex
  <head>
    <%= csrf_meta_tag() %> # 追加
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>TodoTutorial · Phoenix Framework</title>
    <link rel="stylesheet" href="<%= Routes.static_path(@conn, "/css/app.css") %>"/>
  </head>
~~~

~~~js
// assets/js/app.js
import "phoenix_html"

import {Socket} from "phoenix"
import LiveSocket from "phoenix_live_view"

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content");
let liveSocket = new LiveSocket("/live", Socket, {params: {_csrf_token: csrfToken}});
liveSocket.connect()
~~~

以上です。
