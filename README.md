# idam

SYSNET identity a access manager. 


## docker

### ds

https://github.com/ome/apacheds-docker

Apache DS 

    docker build -t sysnetcz/apacheds .
    
    docker run -d --name ldap -p 10389:10389 -t sysnetcz/apacheds
    
    
    
### fortress


