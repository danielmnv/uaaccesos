// Config
require('./environment/config');

const functions = require('firebase-functions');
const fireabse = require ('firebase-admin');
const jwt = require('jsonwebtoken');

fireabse.initializeApp();

const firestore = fireabse.firestore();
const _users = firestore.collection('users');
const _logs = firestore.collection('logs');

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
            let { exists, ref, user } = await _users.doc(decoded.uid).get().then(doc => {
                return { exists: doc.exists, ref: doc.ref, user: doc.data() }
            });

            // Check if exist
            if (exists) {
                let register = await _logs.add({
                    date: fireabse.firestore.Timestamp.fromDate(new Date()),
                    door: data.door,
                    successful: true,
                    user: {
                        ref: ref,
                        email: user.email,
                        name: user.name,
                        ap_pat: user.ap_pat,
                        career: user.career
                    },
                });

                // Return if log added
                if (register.id) return { ok: true, msg: `Acceso permitido: ${user.name} ${user.ap_pat}`, user: user, log: register };
                // Return error
                else return { ok: false, msg: `Ocurrio un error. Intente de nuevo` };

            }
            // Don't allow
            else return { ok: false, msg: "Usuario inexistente" };
        }
    }
    catch(error) {
        // Invalid token
        return { ok: false, unauth: true, msg: "Token caducado", err: error };
    }
});