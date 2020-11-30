// Config
require('./environment/config');

const functions = require('firebase-functions');
const fireabse = require ('firebase-admin');
const jwt = require('jsonwebtoken');

fireabse.initializeApp();

const firestore = fireabse.firestore();
const collection = firestore.collection('users');

exports.createToken = functions.https.onCall((data, context) => {
    let token = jwt.sign({ uid: context.auth.uid }, process.env.PRIVATE_KEY, { expiresIn: process.env.EXPIRATION });

    return { ok: true, jwt: token };
});

exports.validateToken = functions.https.onCall(async (data, context) => {
    try {
        // Token
        let token = data.token;
        // Decode token
        let decoded = jwt.verify(token, process.env.PRIVATE_KEY, { ignoreExpiration: false });

        // Decoded token
        if (decoded) {
            // Get user doc from firestore
            let { exists, user } = await collection.doc(decoded.uid).get().then(doc => {
                return { exists: doc.exists, user: doc.data() }
            });

            // If exist allow access
            if (exists) return { ok: true, msg: `Acceso permitido: ${user.name} ${user.ap_pat}` };
            // Don't allow
            else return { ok: false, msg: "Usuario inexistente" };
        }
    }
    catch(error) {
        // Invalid token
        return { ok: false, unauth: true, msg: "Token caducado", err: error };
    }
});