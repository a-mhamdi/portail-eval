#import "@preview/showybox:2.0.4": showybox

#let pv(nom, prenom, cin, org, titre, notes, jury, date, ref, content) = {
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
        align: (left, center),
        grid(
          columns: auto,
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
    footer-descent: 20%,
  )


  align(center)[#showybox(
      title-style: (boxed-style: (anchor: (x: right, y: horizon))),
      frame: (:), // (title-color: black.lighten(70%)),
      title: "2024-2025",
      width: 70%,
      [#align(center)[#block(width: 80%, text(weight: "bold", size: 28pt, "Fiche du rapporteur"))]],
    )]

  v(.25cm)

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
#let ref = "{{ ref }}"
#let rapporteur = parse_json("{{ notes }}")
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
      table.cell(colspan: 2, align: center, strong[ #titre ]),
      [ *Nom et prénom* ], [ #nom #prenom ],
      [ *CIN* ], [ #cin ],
      [ *Référence* ], [ #ref ],
      [ *Entreprise d'accueil* ], [ #upper(org) ]
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
      [ *Forme du rapport* _(4 points)_ ], [ #rapporteur.r1 ],
      table.cell(colspan: 2)[
        - Style
        - Conformité au guide.
      ],
      [ *Organisation du rapport* _(4 points)_ ], [ #rapporteur.r2 ],
      table.cell(colspan: 2)[
        - Clarté
        - Qualité.
      ],
      [ *Bibliographie* _(4 points)_ ], [ #rapporteur.r3 ],
      table.cell(colspan: 2)[
        - Etude de l'existant
        - Analyse et critique.
      ],
      [ *Synthèse* _(4 points)_ ], [ #rapporteur.r4 ],
      table.cell(colspan: 2)[
        - Choix des solutions
        - Etude économique.
      ],
      [ *Validation* _(4 points)_ ], [ #rapporteur.r5 ],
      table.cell(colspan: 2)[
        - Simulation numérique
        - Essais pratiques.
      ],
      [ *Note globale* _(20 points)_ ], [ #rapporteur.rtot ],
    )
  ]

  #v(.25cm)

  L'étudiant(e) a été évalué(e) le #date.jour à #date.heure par :

  #v(.05cm)

  /*
  #set table(
    fill: (_, y) => if y == 0 { rgb("EAF2F5") } else { none },
  )
  */

  #set table.hline(stroke: 0.6pt)

  #align(center)[
    #table(
      stroke: none,
      columns: (4cm, 4cm, 4cm),
      align: (center, center, center),
      [ *Rapporteur* ],
      table.hline(),
      [ #jury.rapporteur ],
      []
    )
  ]

  /* STOP */
]

#show: doc => pv(nom, prenom, cin, org, titre, rapporteur, jury, ref, date, content)
