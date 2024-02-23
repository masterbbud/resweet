# resweet
Resweet, BrickHack X Project of Danil Donchuk, Brandon Faunce, Jan Li, and Raynard Miot.

## To set up pip environment:

cd server
python -m venv .env
cd .env
cd Scripts
activate
cd ..
cd ..
pip install -r requirements.txt

## To run server locally:

(Make sure pip environment is enabled)
cd server
uvicorn server:app

## To run app:

(Ensure Flutter environment is enabled properly)
cd app
flutter run

## NOTES

Connection to PostgreSQL server must be done locally through a database.json file.
