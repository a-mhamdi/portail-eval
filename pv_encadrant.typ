#let pv(nom, prenom, cin, org, titre, notes, jury, date, content) = {

  // Set the document's basic properties
  set text(font: "Delicious", size: 11pt)

  set document(author: "Dept de génie électrique", title: "Fiche d'évaluation")
  
  set page(
    margin: (left: 2cm, right: 2cm, top: 3cm, bottom: 3cm),
    numbering: none,
    number-align: center,
    header: [
      #set text(10pt)
      #grid(
      	columns: (2fr, auto),
      	align : (left, center),
      	grid(
      		columns: (auto),
      		gutter: 10pt,
      		"Institut Supérieur des Études Technologiques de Bizerte", "Département de Génie électrique"
      		),
  		image("../ISETBZ.png", height: 60%),
      	) 
      	#line(length: 60%)
    ],
    header-ascent: 30%,
    footer: [
      #set text(10pt)
      #align(center)[#line(length: 100%) ISET Bizerte BP. 65 - Campus universitaire 7035 Menzel Abderrahmen \ Tél : 72 57 06 01 Fax : 72 57 24 55 e-Mail : #link("mailto:isetbz@isetbz.rnu.tn")
      ]
    ],
    footer-descent: 20%

  )
  

  // Title row
  align(center)[
    #block(width: 80%, text(weight: "bold", size: 28pt, "Fiche de encadrant"))
  ]

  v(.25cm)

  // Author information
  align(center)[
    #block(text(weight: 400, size: 14pt, "Année Universitaire : 2024-2025"))
  ]

  // Main body
  set par(justify: true)
  
  content
}

#let parse_json(json_string) = {
  // Remove the outer quotes if present
  let cleaned = if json_string.starts-with("\"") and json_string.ends-with("\"") {
    json_string.slice(1, -1)
  } else {
    json_string
  }
  
  // Remove the curly braces
  let content = cleaned.slice(1, -1)
  
  // Split into key-value pairs
  let pairs = content.split(", ")
  
  // Parse each pair into a dictionary
  let result = (:)
  for pair in pairs {
    let (key, value) = pair.split(": ")
    // Remove quotes from key and value
    key = key.slice(1, -1)
    value = value.slice(1, -1)
    result.insert(key, value)
  }
  
  return result
}

#let nom = "{{ nom }}"
#let prenom = "{{ prenom }}"
#let cin = "{{ cin }}"
#let org = "{{ org }}"
#let titre = "{{ titre }}"
// #let identifiant = "{{ identifiant }}"
#let encadrant = parse_json("{{ notes }}")
#let date = parse_json("{{ date }}")
#let jury = parse_json("{{ jury }}")

#let content = [
/* START */

// See the strokes section for details on this!
#let frame(stroke) = (x, y) => (
  left: if x > 0 { 0pt } else { stroke },
  right: stroke,
  top: if y < 1 { stroke } else { 0pt },
  bottom: stroke,
)

#set table(
  fill: (_, y) => if calc.odd(y) { rgb("EAF2F5") },
  stroke: frame(rgb("21222C")),
)

#v(.25cm)

#align(center)[
  #table(
    columns: (5cm, 7cm),
    align: (left, center),
    table.cell(colspan: 2, strong[ #titre ]),
    [ *Nom et prénom* ], [ #nom #prenom ],
    [ *CIN* ], [ #cin ],
    // [ *N° d'inscription* ], [ #identifiant ],
    // [ *Classe* ], [ #classe ],
    [ *Entreprise  d'accueil* ], [ #upper(org) ]
  )
]

#set table(
  fill: (_, y) => if calc.odd(y) { rgb("EEE") },
  stroke: frame(rgb("21222C")),
)

#v(.25cm)

#align(center)[
  #table(
    columns: (9cm, 3cm),
    inset: 10pt,
    align: (left, center),
    [ *Exposé* _(3 points)_ ], [ #encadrant.e1 ],
    table.cell(colspan: 2)[
      - Qualité des transparents
      - Organisation.
      ],
    [ *Communication* _(3 points)_ ], [ #encadrant.e2 ],
    table.cell(colspan: 2)[
      - Expression orale
      - Rythme et éloquence.
      ],
    [ *Contenu* _(8 points)_ ], [ #encadrant.e3 ],
    table.cell(colspan: 2)[
      - Taux de réalisation
      - Pertinence des résultats
      - Cohérence et validité des résultats.
    ],
    [ *Discussion* _(6 points)_ ], [ #encadrant.e4 ],
    table.cell(colspan: 2)[
      - Qualité de la présentation
      - Réponses aux questions.
    ],
    [ *Note globale* _(20 points)_ ], [ #encadrant.etot ],
  )
]

#v(.25cm)

  L'étudiant(e) a été évalué(e) le #date.jour à #date.heure par :

#v(.05cm)

#set table(
  fill: (_, y) => if y == 0 { rgb("EAF2F5") } else { none },
)

#set table.hline(stroke: 0.6pt)

#align(center)[
  #table(
    stroke: none,
    columns: (4cm, 4cm, 4cm),
    align: (center, center, center),
    [ *Président* ], [ *Rapporteur*], [ *Encadrant(s)* ],
    table.hline(),
    [ #jury.president ], [ #jury.rapporteur ], [ #jury.encadrant ],
    [], [], []
  )
]

/* STOP */
]

#show: doc => pv(nom, prenom, cin, org, titre, encadrant, jury, date, content)
