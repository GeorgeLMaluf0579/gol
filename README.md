# GOL - Conway's Game of Life
This project is a response to the [challenge](CHALLENGE.md) proposed by Extendi.

## Technical Stack
- Ruby on Rails
- Docker
- RSpec

## Requirements
Any computer with a good Internet connection with docker and docker-compose already installed.


## 📦 Setup
## 1. Clone the github repo
  ```bash
  $ git clone https://github.com/GeorgeLMaluf0579/gol.git && cd gol 
  ```
## 2. Build the docker containers
  ```bash
  $ make docker-build
  ```
  This process can take a while depending on your computer and Internet connection speed. Please be patient.

### 3. Setup databse 
  ```bash
  $ make docker-setupdb
  ```

## Running the project 
After setup the docker containers and database properly, use the following command lines:
```bash
  $ make docker-run
  ```
  Open your favorite browser and point to the following URL
  ```
  http://localhost:3000
  ```

## 🤖 Automated tests and code coverage
```
$ make docker-tests
```
A folder called `coverage` will be created or updated on the root of the project. A file called index.html contains all the code coverage report.

## 👨🏻‍💻 Autor
Made by George Luiz 'Maverick' Maluf

<b> 📫 How to reach me</b>
<div>
  <a href="https://www.linkedin.com/in/%F0%9F%91%A8%F0%9F%8F%BB%E2%80%8D%F0%9F%92%BB-george-l-maluf-24225733/"><img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white"></a>
  <a href="https://api.whatsapp.com/send?phone=554298337945"><img src="https://img.shields.io/badge/WhatsApp-25D366?style=for-the-badge&logo=whatsapp&logoColor=white"></a>
  <a href="mailto:georgelmaluf286@gmail.com"><img src="https://img.shields.io/badge/Gmail-D14836?style=for-the-badge&logo=gmail&logoColor=white"></a>
</div>
