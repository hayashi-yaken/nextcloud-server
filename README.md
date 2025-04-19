# 🥊 アプリ制作 100 本ノック - 2 本目「nextcloud-server」

Tailscale × Docker を活用して、安全かつ自分専用の Nextcloud 環境をオンプレミスに構築するプロジェクトです。自己署名証明書による HTTPS 対応や、ホストと分離された config.php 設定により、簡単に再現できる安全な構成を実現しています。

## 📌 1. アプリの概要

nextcloud-server は以下のような目的で構築されています：

- 自分だけのプライベートクラウド環境を作りたい
- Tailscale を使って特定ユーザーだけアクセス可能にしたい
- 再現性の高い Docker 構成で管理・運用したい

主な特徴

- ✅ Docker Compose で一発起動
- 🔒 自己署名証明書による HTTPS 通信
- 🧑‍🤝‍🧑 Tailscale を使ったアクセス制限
- 📂 ファイル・DB 両方のバックアップを簡単に実行可能
- ⚙️ 設定ファイルはすべて Git 管理対象に集約

## ⚙️ 2. 使用技術と構成

| 分類             | 使用技術                       |
| ---------------- | ------------------------------ |
| クラウドソフト   | Nextcloud                      |
| データベース     | MariaDB                        |
| リバースプロキシ | Nginx + 自己署名 SS L          |
| VPN アクセス制御 | Tailscale                      |
| コンテナ管理     | Docker / Docker Compose        |
| バックアップ     | Shell スクリプト + cron 対応可 |

### ディレクトリ構成

```bash
nextcloud-server/
├── docker-compose.yml
├── .env
├── nginx/
│   └── conf/
├── certs/
├── nextcloud/
│   └── custom-php.ini
├── backup/
│   ├── db/
│   ├── data/
│   ├── config/
│   └── backup.sh
```

🛠 3. セットアップ方法

前提条件
• Docker / Docker Compose インストール済み
• Tailscale アカウントにログイン済み
• .ts.net 経由でアクセスできる環境（HTTPS 有効）

セットアップ手順

```bash
# リポジトリをクローン
git clone https://github.com/yourname/nextcloud-server.git
cd nextcloud-server

# .env ファイルを作成して環境変数を設定（例）
cp .env.example .env
```

.env ファイルの例

```bash
MYSQL_ROOT_PASSWORD=your-root-password
MYSQL_DATABASE=nextcloud
MYSQL_USER=nextcloud
MYSQL_PASSWORD=your-password
```

自己署名証明書の作成

```bash
mkdir -p certs
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout certs/selfsigned.key \
  -out certs/selfsigned.crt \
  -subj "/C=JP/ST=Tokyo/L=Shibuya/O=Nextcloud/OU=IT/CN=nextcloud.local"
```

docker コンテナ起動

```bash
docker compose up -d
```

ブラウザにアクセス

```bash
https://<your-server>.ts.net
```

自己署名証明書のため、ブラウザによって警告が出ることがあります。初回はブラウザの警告を「続行」でスキップしてください。

💾 バックアップの使い方

```bash
./backup.sh
```

バックアップ内容：
| 対象 | 保存先｜
|---|---|
|MariaDB|./backup/db/|
|ファイル|./backup/data/|
|設定|./backup/config/|

## 🔐 4. 他の Tailscale ユーザーにアクセスを許可する

#### この方法は, 有料プランに加入する必要があります。加入しない場合は, 1 つのアカウントを複数人で使用することになります。

このプロジェクトでは、Tailscale を使用して Nextcloud へのアクセスを制限しています。デフォルトでは自分のアカウントに紐づいた端末のみアクセスできますが、以下の手順で別のユーザー（チームメンバーなど）にもアクセスを許可できます。

1. Tailscale 管理画面 にログイン
2. 「Edit ACLs」ボタンをクリック
3. 以下のような ACL（アクセス制御ルール）を追加：

```json
{
  "ACLs": [
    {
      "Action": "accept",
      "Users": ["*"], // すべてのユーザーに許可（必要に応じて制限）
      "Ports": ["nextcloud-server:443"]
    }
  ],
  "Hosts": {
    "nextcloud-server": "100.x.x.x" // あなたの Nextcloud サーバーの Tailscale IP
  }
}
```

ユーザーを絞りたい場合

```json
"Users": ["alice@example.com", "bob@example.com"]
```

同じドメインのチーム全体に許可する場合

```json
"Users": ["*@yourcompany.com"]
```

4. 「Apply ACL Changes」をクリックして保存

## 🚧 5. 今後の実装予定

- 🔄 自動バックアップと復元用スクリプトの追加
- 📱 クライアントアプリ（iOS / Android / macOS / Windows）との連携手順ドキュメント
- 🧩 便利な Nextcloud アプリの推奨一覧
- 💬 初回セットアップ完了後の通知 / アラート対応
