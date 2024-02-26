# Use an official Apache image as the base
FROM httpd:2.4

# Add ServerName directive
RUN echo "ServerName localhost" >> /usr/local/apache2/conf/httpd.conf

# Install ModSecurity and other required modules
RUN apt-get update && \
    apt-get install -y libapache2-mod-security2

# Enable ModSecurity module
RUN sed -i '/<\/IfModule>/i\LoadModule security2_module modules/mod_security2.so\nLoadModule unique_id_module modules/mod_unique_id.so' /usr/local/apache2/conf/httpd.conf

# Copy ModSecurity configuration file
COPY modsecurity.conf /etc/modsecurity/modsecurity.conf

# Include ModSecurity configuration in Apache
RUN echo "Include /etc/modsecurity/modsecurity.conf" >> /usr/local/apache2/conf/httpd.conf

# Update the path to the ModSecurity module
RUN sed -i 's#modules/mod_security2.so#/usr/lib/apache2/modules/mod_security2.so#' /usr/local/apache2/conf/httpd.conf

# Expose port 80
EXPOSE 80
