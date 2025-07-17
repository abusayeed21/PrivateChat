#!/bin/bash

echo "🚀 Auto Setup Starting..."

# Step 1: Install dependencies
sudo apt update
sudo apt install -y nodejs npm mysql-server unzip curl

# Step 2: Start MySQL and secure
sudo systemctl start mysql
sudo systemctl enable mysql

# Step 3: Set MySQL root password & create DB
echo "📦 Setting up MySQL root password and database..."
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';"
sudo mysql -e "CREATE DATABASE IF NOT EXISTS chatapp;"
sudo mysql -u root -proot < init.sql
echo "✅ Database and tables created."

# Step 4: Create .env file
echo "🔧 Creating .env file..."
cat <<EOF > .env
DB_HOST=localhost
DB_USER=root
DB_PASSWORD=root
DB_NAME=chatapp
PORT=3000
EOF
echo "✅ .env file generated."

# Step 5: Install Node dependencies
echo "📦 Installing Node.js modules..."
npm install

# Step 6: Setup PM2 for auto-run
echo "🛠 Setting up PM2..."
sudo npm install -g pm2
pm2 start server.js --name chatapp
pm2 save
pm2 startup systemd -u $(whoami) --hp $(eval echo ~$(whoami))
echo "✅ PM2 setup complete."

echo "🎉 DONE! Open: http://your-vps-ip:3000"
