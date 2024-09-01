# Pterodactyl Builder

### Build Images

```bash
./build.sh
```

Then you will get two images: `pterodactyl-panel` and `pterodactyl-nginx`, you can push them to your registry.

### Usage

#### Create Network

```bash
docker network create pterodactyl
```

#### Create Containers

**It is NOT suggested to change the name of the container named `pterodactyl-panel` as it was referred in `nginx-site.conf`**  
**If must, you should do some change in `nginx-site.conf` at the same time**

```bash
docker run -itd --name pterodactyl-panel --network pterodactyl -e "YOUR_ENVIRONMENT_HERE" -v /var/www/html pterodactyl-panel
# DO NOT FORGET TO ADD ENVIRONMENT VARIABLES
docker run -itd --name pterodactyl-nginx --network pterodactyl --volumes-from pterodactyl-panel -p 80:80 pterodactyl-nginx
```

#### Configure Pterodactyl and Add First User

```bash
docker exec -it pterodactyl-panel php artisan key:generate --force
docker exec -it pterodactyl-panel php artisan p:environment:setup
docker exec -it pterodactyl-panel php artisan p:environment:database
docker exec -it pterodactyl-panel php artisan p:environment:mail
docker exec -it pterodactyl-panel php artisan migrate --seed --force

# Add first user
docker exec -it pterodactyl-panel php artisan p:user:make
```

#### Create Containers for Queue and Schedule

```bash
docker run -itd --name pterodactyl-schedule --network pterodactyl --volumes-from pterodactyl-panel pterodactyl-panel php /var/www/html/artisan schedule:work
docker run -itd --name pterodactyl-queue --network pterodactyl --volumes-from pterodactyl-panel pterodactyl-panel php /var/www/html/artisan queue:work --queue=high,standard,low --sleep=3 --tries=3
```
