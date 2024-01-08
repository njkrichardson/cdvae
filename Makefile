build : 
	docker build --tag cdvae:latest .

download : 
	python3 scripts/download_data.py

run : 
	docker run -dt --gpus all -v "$(pwd)":"/cdvae" --name cdvae cdvae:latest /bin/zsh
