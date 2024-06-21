# Use the official PHP image as the base image
FROM php:8.1-apache

# Set the working directory inside the container
WORKDIR /var/www/html

# Copy the current directory contents into the container at /var/www/html
COPY . .

# Optionally enable Apache mod_rewrite (if needed)
RUN a2enmod rewrite

# Expose port 80 to the outside world
EXPOSE 80

# Start Apache server in the foreground
CMD ["apache2-foreground"]