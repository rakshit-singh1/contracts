const nodemailer = require("nodemailer");

const transporter = nodemailer.createTransport({
    service: "gmail",
    port: 587,
    secure: true,
    auth: {
        user: "rakshit.singh@indicchain.com",
        pass: "mefr ghxr ysdv ovuv",
    },
});

// async..await is not allowed in global scope, must use a wrapper
module.exports.sendMail = async(trans, from, amount) => {
    try
    {
        const info = await transporter.sendMail({
            from: '"rakshit.singh@indicchain.com', // sender address
            to: "rs7162@dseu.ac.in", // list of receivers
            subject: `Transaction hash: ${trans}`, // Subject line
            text: `A transaction completed from ${ from } of amount ${ amount } ethers`, // plain text body
        });
    
        console.log("Message sent: %s", info.messageId);
        // Message sent: <b658f8ca-6296-ccf4-8306-87d57a0b4321@example.com>
        //
        // NOTE: You can go to https://forwardemail.net/my-account/emails to see your email delivery status and preview
        //       Or you can use the "preview-email" npm package to preview emails locally in browsers and iOS Simulator
        //       <https://github.com/forwardemail/preview-email>
        //
    }
    catch(error){
        console.log("Error: ",error)
    }
}
