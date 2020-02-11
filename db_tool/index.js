var admin = require("firebase-admin");
var serviceAccount = require("/Users/svenja/Documents/dontplayalone-251610-firebase-adminsdk-e70eb-8c91bfe049.json");
admin.initializeApp({
    credential: admin.credential.cert(serviceAccount)
});
const db = admin.firestore();

async function readCollectionsContent() {
    let collections = await db.listCollections();
    for (let collection of collections) {
        console.log(`\n\n\nFound collection with id: ${collection.id}\n`);
        await readFromCollection(collection.id);
    }
}

async function readFromCollection(id) {
    let snapshot = await db.collection(id).get();
    snapshot.forEach((doc) => {
        console.log(doc.id, '=>', doc.data());
    });
}

async function deleteCollectionContent(id) {
    let snapshot = await db.collection(id).get();
    let docs = snapshot.docs;
    for(let index in docs) {
        let doc = docs[index];
        await db.collection(id).doc(doc.id).delete().then((success) => console.log(doc.id, ' deleted - success: ' + success));
    }
}

