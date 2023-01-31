#!/usr/bin/python3
from flask import Flask, request, jsonify,redirect,render_template,url_for
from pymongo import MongoClient
from datetime import datetime,date
from bson import json_util
import csv,json,os 
from bson.objectid import ObjectId
import subprocess
app = Flask(__name__)

client = MongoClient('my_db', username='root', password='password')
db = client
# def get_db(name):
#     db = client[name]
#     return db

@app.route('/')
def home():
    return render_template("index.html")

@app.get('/<comp>/')
def get_comp(comp):
    comp_db=db.get_database(comp)
    # return json_util.dumps(list(comp_db.diver.find()))
    return render_template("comp_get.html",result=list(comp_db.diver.find()),NAME=str(comp))

@app.put('/<comp>/')
def update_comp(comp):
    _id = request.form.get('diver_id')
    firstName = request.form.get('firstName')
    lastName = request.form.get('lastName')
    meter = request.form.get('meter')
    discipline = request.form.get('discipline')
    time = request.form.get('time')
    country = request.form.get('country')
    NR = request.form.get('NR')
    gender = request.form.get('gender')
    doc={
    "firstName":firstName
    ,"lastName":lastName
    ,"meter":meter
    ,"discipline":discipline
    ,"time":time
    ,"country":country
    ,"NR":NR
    ,"gender":gender
    }
    comp_db=db.get_database(comp)
    for key, value in doc.items():
        if value is None or value == "":
            return (f"{key} is null")
            
    if not list(comp_db.diver.find({"_id":_id})) :
        return "diver not here" ,404

    
    myquery = { "_id":_id }
    newvalues = { "\$set":  doc  }

    comp_db.diver.update_one(myquery,newvalues)

   
   
    return json_util.dumps(list(comp_db.diver.find({"_id":_id})))

@app.delete('/<comp>/<id>/')
def del_diver(comp,id):
    comp=str(comp).lower
    comp_db=db.get_database(comp)
    myquery = { "_id": id }
    if not list(comp_db.diver.find({"_id": id})) :
        return "diver not here to delete" ,404
    comp_db.diver.delete_one(myquery)
    return "diver was deleted"


@app.get('/drop/<comp>/')
def drop_data(comp):
    comp=str(comp).lower
    comp_db=db.get_database(comp)
    comp_db.diver.drop()
    return "drop "+ str(comp)
    
@app.post('/<comp>/')
def add_comp(comp):
    comp=str(comp).lower
    _id = request.form.get('_id')
    firstName = request.form.get('firstName')
    lastName = request.form.get('lastName')
    meter = request.form.get('meter')
    discipline = request.form.get('discipline')
    time = request.form.get('time')
    country = request.form.get('country')
    NR = request.form.get('NR')
    gender = request.form.get('gender')
    doc={
    "_id":_id
    ,"firstName":firstName
    ,"lastName":lastName
    ,"meter":meter
    ,"discipline":discipline
    ,"time":time
    ,"country":country
    ,"NR":NR
    ,"gender":gender
    }
    
    comp_db=db.get_database(comp)

    for key, value in doc.items():
        if value is None or value == "":
            return (f"{key} is null")
    try:
        comp_db.diver.insert_one(doc)
        return redirect('/'+comp+'/')
        # return json_util.dumps(list(comp_db.diver.find({"_id":_id})))
    except:
        return "diver is on the list" ,404



@app.get('/<comp>/id/<id>/')
def get_diver_id(comp,id):
    comp=str(comp).lower
    comp_db=db.get_database(comp)
    return json_util.dumps(list(comp_db.diver.find({"_id":id})))

@app.get('/<comp>/discipline/<discipline>/')
def get_discipline(comp,discipline):
    comp=str(comp).lower
    comp_db=db.get_database(comp)
    return json_util.dumps(list(comp_db.diver.find({"discipline":discipline})))

@app.get('/<comp>/gender/<gender>')
def get_gender(comp,gender):
    comp=str(comp).lower
    comp_db=db.get_database(comp)
    return json_util.dumps(list(comp_db.diver.find({"gender":gender})))

@app.get('/<comp>/nr/<NR>/')
def get_NR(comp,NR):
    comp=str(comp).lower
    comp_db=db.get_database(comp)
    return json_util.dumps(list(comp_db.diver.find({"NR":NR})))
    
@app.get('/<comp>/country/<country>/')
def get_country(comp,country):
    comp_db=db.get_database(comp)
    return json_util.dumps(list(comp_db.diver.find({"country":country})))



@app.route('/check/')
def get_check():
    
    # comp_db=db.get_database(comp)
    # comp_db.user.insert_one({"name":"shoval"})
    return json_util.dumps(list(db.list_database_names()))

@app.route('/health/')
def get_health():
   return "OK 200"



if __name__ == "__main__":
    app.run(host="0.0.0.0", debug=True)