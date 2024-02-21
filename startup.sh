docker network create pterodactyl
docker run -itd --name pterodactyl-panel --network pterodactyl -v /var/www/html pterodactyl-panel
# DO NOT FORGET TO ADD ENVIRONMENT VARIABLES
docker run -itd --name pterodactyl-nginx --network pterodactyl --volumes-from pterodactyl-panel -p 80:80 pterodactyl-nginx

docker exec -it pterodactyl-panel php artisan key:generate --force
docker exec -it pterodactyl-panel php artisan p:environment:setup
docker exec -it pterodactyl-panel php artisan p:environment:database
docker exec -it pterodactyl-panel php artisan p:environment:mail
docker exec -it pterodactyl-panel php artisan migrate --seed --force

# Add first user
docker exec -it pterodactyl-panel php artisan p:user:make

# After configure successfully
docker run -itd --name pterodactyl-schedule --network pterodactyl --volumes-from pterodactyl-panel pterodactyl-panel php /var/www/html/artisan schedule:work
docker run -itd --name pterodactyl-schedule --network pterodactyl --volumes-from pterodactyl-panel pterodactyl-panel php /var/www/html/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
