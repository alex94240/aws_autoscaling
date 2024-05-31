## Q1. Création d'une instance EC2

Utilisation d'un backend local pour cet exercice. Pour initialiser le terraform, lancer `terraform init`.

Pour la création d'une instance t2.micro dans le default vpc de eu-west-1, lancer `terraform apply`.

## Q2. Ajout d'un accès à notre EC2

Pour accéder à notre EC2 on va créer un security group qui autorise notre IP sur tous les protocoles/port,
on peut renseigner une autre IP custom via le fichier `shared.tfvars`. Pour cela il y a 2 options:
* lancer l'apply, on aura ensuite un prompt nous demandant la valeur de la variable (attention à bien renseinger sous le format <VOTRE_IP>/32)
* on peut aussi utiliser le fichier shared.tfvars, il faudra par contre le renseigner au moment de l'apply `terraform apply -var-file="../shared.tfvars"`

## Q3. Ajout d'un rôle d'écriture sur S3 pour notre EC2

Ajout d'une nouvelle layer s3 et d'un instance rôle sur notre EC2 qui nous permet d'écrire dans le S3 (uniquement des objets avec le préfixe "can_be_written"). Lancer l'init puis apply dans 01_s3 en n'oubliant pas de renseigner le var-file puis apply pour mettre à jour l'ec2 avec le nouvel instance rôle.

## Q4. Ajout d'un script d'installation

On a ajouté un fichier `install.sh` qui permet de lancer des commandes à l'initialisation de notre EC2. Pour cela on va lancer un apply dans le dossier `10_ec2` et updater l'instance. Après un redémarrage, docker et docker-compose sont maintenant bien installés.

## Q5. Lancement du serveur

On ajoute 2 lignes à notre script, une pour lancer le service docker et une autre pour run l'image du serveur.
On peut s'y connecter directement via notre navigateur à l'aide de l'ip publique (ex:`<IP_EC2>:1080/mockserver/dashboard`).

## Q6. Haute disponibilité des serveurs

Pour avoir de la HA sur notre service, on pourrait mettre un application load balancer avec un target group en cible qui contiendrait deux instances dans 2 différentes AZ par exemple. Cela nous permettrait d'utiliser un groupe d'autoscaling avec pour garder notre service up dans une configuration minimale.
