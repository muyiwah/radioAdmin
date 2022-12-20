const functions = require("firebase-functions");
const admin = require('firebase-admin');
admin.initializeApp();
// const serviceAccount = require(`${__dirname}/<path-to-key>.json`);
// admin.initializeApp({credential: admin.credential.cert(serviceAccount)});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
// exports.sendNotification = functions.https.onCall((data, context) => {
//     const payload = {
//         notification: {
//             title: "The title of the notification",
//             body: "datayour_param_sent_from_the_client", //Or you can set a server value here.
//         },
//         //If you want to send additional data with the message,
//         //which you dont want to show in the notification itself.
//         data: {
//             data_to_send: "msg_from_the_cloud",
//         }
//     };
//     admin.messaging().sendToTopic("AllPushNotifications", payload)
//         .then(value => {
//             console.info("function executed succesfully");
//             return { msg: "function executed succesfully" };
//         })
//         .catch(error => {
//             console.info("error in execution");
//             console.log(error);
//             return { msg: "error in execution" };
//         });
// });
exports.waterradio= functions.https.onCall((data, context) => {
    const title = data.title;
    const body = data.body;
    const payload2 = {
        notification: {
            title: title,
            body: body, //Or you can set a server value here.
            //  imageUrl: "https://www.gstatic.com/webp/gallery3/1.sm.png",
            
        },
        //If you want to send additional data with the message,
        //which you dont want to show in the notification itself.
        data: {
            data_to_send: "msg_from_the_cloud",
        }
    };
    admin.messaging().sendToTopic("AllPushNotifications2", payload2)
    .then(value => {
        console.info("function executed succesfully");
        return { msg: "function executed succesfully" };
    })
    .catch(error => {
        console.info("error in execution");
        console.log(error);
        return { msg: "error in execution" };
    });
});
exports.zionwayradio= functions.https.onCall((data, context) => {
    const title = data.title;
    const body = data.body;
    const payload2 = {
        notification: {
            title: title,
            body: body, //Or you can set a server value here.
            //  imageUrl: "https://www.gstatic.com/webp/gallery3/1.sm.png",
            
        },
        //If you want to send additional data with the message,
        //which you dont want to show in the notification itself.
        data: {
            data_to_send: "msg_from_the_cloud",
        }
    };
    admin.messaging().sendToTopic("zionwayradioPush", payload2)
    .then(value => {
        console.info("function executed succesfully");
        return { msg: "function executed succesfully" };
    })
    .catch(error => {
        console.info("error in execution");
        console.log(error);
        return { msg: "error in execution" };
    });
    });
    exports.trccradio= functions.https.onCall((data, context) => {
        const title = data.title;
        const body = data.body;
        const payload2 = {
            notification: {
                title: title,
                body: body, //Or you can set a server value here.
                //  imageUrl: "https://www.gstatic.com/webp/gallery3/1.sm.png",
                
            },
            //If you want to send additional data with the message,
            //which you dont want to show in the notification itself.
            data: {
                data_to_send: "msg_from_the_cloud",
            }
        };
        admin.messaging().sendToTopic("trccradioPush", payload2)
        .then(value => {
            console.info("function executed succesfully");
            return { msg: "function executed succesfully" };
        })
        .catch(error => {
            console.info("error in execution");
            console.log(error);
            return { msg: "error in execution" };
        });
        });