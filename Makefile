build : 
	docker build --tag cdvae:latest .

run : 
	docker run -dt --gpus all -v "$(pwd)":"/cdvae" --name cdvae cdvae:latest /bin/zsh
