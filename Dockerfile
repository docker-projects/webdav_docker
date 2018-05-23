# Use an official Python runtime as a parent image
FROM ubuntu:18.04


#Crear usuario con permisos root
RUN adduser web_dav
RUN usermod -aG sudo web_dav
#web_18

# 1) Installing Apache
RUN apt-get update
RUN apt-get install apache2 -y

# 2) Setting Up WebDAV

#2.1) Preparing the Directory
RUN mkdir /var/www/webdav
RUN chown -R www-data:www-data /var/www/

#2.2)Enabling Modules
RUN a2enmod dav
RUN a2enmod dav_fs

# Copy WebDav configuration file
COPY 000-default.conf /etc/apache2/sites-available/

#Example File 
RUN echo "this is a sample text file" | tee -a /var/www/webdav/sample.txt

# 4) Digest Authentication
RUN apt-get install apache2-utils

#Add example user
RUN htdigest -c /etc/apache2/users.password webdav jcorvi

#Set permissions to sec file
RUN chown www-data:www-data /etc/apache2/users.password

# 5) Enable Digest Security
RUN a2enmod auth_digest
RUN a2enmod authz_groupfile
# Install Password Generator
#RUN apt-get install pwgen

# NANO
RUN apt-get install nano

# Set the working directory to /app
WORKDIR /app

# This is to generate password for several users at the conteiner when its generated
# Copy the users for the security and password generator
#COPY users.txt /app
# Copy de bash script for generate password
#COPY password_generator.sh /app
#Set permissions
#RUN chmod 777 password_generator.sh
# Run script
#RUN ./password_generator.sh
# Copy passwords results into the apache security passwords file
#RUN cp passwd.htdigest /etc/apache2/users.password


# Or we can copy the file from outside.
COPY passwd.htdigest /etc/apache2/users.password
COPY groups /etc/apache2/groups

#Restart Apache
#RUN service apache2 start

#To Run the Container
#docker run -it -p 8081:80 -v /home/youruser/your_data_path/:/var/www/webdav/  apache_webdav


