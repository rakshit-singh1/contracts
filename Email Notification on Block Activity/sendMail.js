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
    }
    catch(error){
        console.log("Error: ",error)
    }
}
