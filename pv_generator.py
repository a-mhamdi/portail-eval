#!.venv/bin/python

import os
import sys
import logging
import json

from pymongo import MongoClient
from jinja2 import Template

# Setup basic logging
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')


# Connect to MongoDB
def fetch_data_from_mongo(db_name, collection_name, cin):
    client = MongoClient('mongodb://0.0.0.0:27017/')
    db = client[db_name]
    collection = db[collection_name]
    # Returns a cursor of documents
    return collection.find({"cin": cin})


# Check if document is valid
def validate_document(document):
    required_fields = ['nom', 'prenom', 'cin', 'jury',
                       'org', 'titre', 'notePresident', 'noteRapporteur', 'noteEncadrant', 'date']
    for field in required_fields:
        if field not in document:
            logging.warning(
                "Document missing required field '%s': %s", field, document)
            return False
    return True


# Generate Typst document from a template and MongoDB data
def generate_typst_file(document, notes, date, template, cin, file_name):
    try:
        # Directory to store the generated Typst files
        output_dir = "dir_pv/" + cin
        os.makedirs(output_dir, exist_ok=True)
        file_path = os.path.join(output_dir, cin + '_' + file_name)

        typst_content = template.render(
            nom=document['nom'],
            prenom=document['prenom'],
            cin=document['cin'],
            org=document['org'],
            titre=document['titre'],
            notes = notes,
            jury=document['jury'],
            date=date
        )
        # Save the rendered content to a Typst file
        with open(file_path, 'w') as f:
            f.write(typst_content)
            logging.info("Generated Typst file: %s", file_path)

    except Exception as e:
        logging.error(
            "Failed to generate Typst file for document: %s", document)
        logging.error(e)


def template_filler(document, date, cin, flag='j', notes=None):

    file_name = {
        's': 'soutenance.typ',
        'r': 'rapporteur.typ',
        'e': 'encadrant.typ',
        'j': 'jury.typ'
    }

    with open('pv_' + file_name[flag], 'r') as f:
        typst_template = f.read()

    # Compile the template with Jinja2
    template = Template(typst_template)

    # Generate Typst files
    generate_typst_file(document, notes, date, template, cin, file_name[flag])


def main():

    # MongoDB configuration
    db_name = "dept-ge"
    collection_name = "raia_s"

    # Fetch data from MongoDB
    cin = sys.argv[1] if len(sys.argv) > 1 else '123'
    data = fetch_data_from_mongo(db_name, collection_name, cin)

    if data is None:
        logging.error("No data fetched from MongoDB.")
        return

    document = data[0]
    if validate_document(document):
        notePresident = document['notePresident']
        noteRapporteur = document['noteRapporteur']
        noteEncadrant = document['noteEncadrant']

        soutenance = json.dumps({
            'p1': str(notePresident['p1']),
            'p2': str(notePresident['p2']),
            'p3': str(notePresident['p3']),
            'p4': str(notePresident['p4']),
            'ptot': str(notePresident['ptot']),
        }).replace('"', "'")

        rapporteur = json.dumps({
            'r1': str(noteRapporteur['r1']),
            'r2': str(noteRapporteur['r2']),
            'r3': str(noteRapporteur['r3']),
            'r4': str(noteRapporteur['r4']),
            'r5': str(noteRapporteur['r5']),
            'rtot': str(noteRapporteur['rtot']),
        }).replace('"', "'")

        encadrant = json.dumps({
            'e1': str(noteEncadrant['e1']),
            'e2': str(noteEncadrant['e2']),
            'e3': str(noteEncadrant['e3']),
            'e4': str(noteEncadrant['e4']),
            'e5': str(noteEncadrant['e5']),
            'etot': str(noteEncadrant['etot'])
        }).replace('"', "'")

        evaluation = json.dumps({
            'ne': str(noteEncadrant['etot']),
            'ne_part': str(.3 * noteEncadrant['etot']),
            'nr': str(noteRapporteur['rtot']),
            'nr_part': str(.3 * noteRapporteur['rtot']),
            'np': str(notePresident['ptot']),
            'np_part': str(.4 * notePresident['ptot']),
            'ntot': str(.3 * noteEncadrant['etot'] + .3 * noteRapporteur['rtot'] + .4 * notePresident['ptot'])
        }).replace('"', "'")

        dt = document['date']
        date = json.dumps({'jour': dt['jour'], 'heure': dt['heure']}).replace('"', "'")

        # Render Typst content with data
        template_filler(document, date, cin, flag='s', notes=soutenance)
        template_filler(document, date, cin, flag='r', notes=rapporteur)
        template_filler(document, date, cin, flag='e', notes=encadrant)
        template_filler(document, date, cin, flag='j', notes=evaluation)

# Run the script
if __name__ == "__main__":
    main()
