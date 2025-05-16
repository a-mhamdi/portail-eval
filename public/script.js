async function checkFileExists(url) {
    try {
        const response = await fetch(url, {
            method: 'HEAD' // Using HEAD request as it's lighter than GET
        });

        return response.ok; // Returns true if status is 200-299
    } catch (error) {
        console.error('Error checking file:', error);
        return false;
    }
}

let student_id = null;

document.getElementById('retrieve-button').addEventListener('click', async function () {
    const cin = document.getElementById('cin').value;

    const url = `/api/data?cin=${encodeURIComponent(cin)}`;

    await fetch(url)
        .then(response => response.json())
        .then(data => {
            // Handle the retrieved data here
            if (data.length > 0) {
                student_id = data[0]._id;
                const student = data[0].prenom + ' ' + data[0].nom;

                document.getElementById('student').innerHTML = `<h2 style="color: #333; font-size: 24px; margin: 0;">${student}</h2>`;

                const thePDFfile = `/uploads/raia/${student_id}.pdf`;

                checkFileExists(thePDFfile)
                    .then(exists => {
                        if (exists) {
                            rapport.innerHTML = `<iframe src=${thePDFfile} width="90%" height="1000px" loading="lazy"></iframe>`;
                        } else {
                            rapport.innerHTML = `<div style="text-align: center; padding: 20px; background-color: #fff3f3; border: 1px solid #ffcdd2; border-radius: 4px; margin: 10px 0;"><h3 style="color: #d32f2f; margin: 0 0 10px 0;">Erreur</h3><p style="color: #555; margin: 0;">Une erreur s'est produite lors de la vérification du fichier. Veuillez réessayer ultérieurement. Si le problème persiste, contactez l'unité des stages.</p></div>`;
                        }
                    });

            }
        })
        .catch(error => {
            console.error('Error retrieving data:', error);
        });
});

document.getElementById('saveBtn').addEventListener('click', function () {

    const opts = {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(notePresident)
            };

            // Send data to server using fetch API
            fetch('/api/president', opts)
                .then(response => {
                    if (!response.ok) {
                        throw new Error('Network response was not ok');
                    }
                    return response.json();
                })
                .then(data => {
                    // console.log('Success:', data);
                    // console.log(data.msg);
                    // console.log(data.body);
                    // Redirect after saving
                    // window.location.href = 'thanks.html';
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Failed to save data. Please try again.');
                });

});

let notePresident = null;

function updateSum() {

            const p1 = parseFloat(document.getElementById('p1').value) || 0;
            const p2 = parseFloat(document.getElementById('p2').value) || 0;
            const ptot = p1 + p2;
            document.getElementById('note').innerText = ptot;
            notePresident = {
                p1: p1,
                p2: p2,
                ptot: ptot
            };
}

        document.getElementById('p1').addEventListener('input', updateSum);
        document.getElementById('p2').addEventListener('input', updateSum);

document.getElementById('printBtn').addEventListener('click', function () {
    print();
});

function print() {
    console.log('Impression en cours...');
}