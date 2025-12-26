package com.onlineshop.util;

import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;
import java.util.logging.Logger;

public class EmailUtil {
    private static final Logger logger = Logger.getLogger(EmailUtil.class.getName());

    //邮件服务器配置
    private static final String SMTP_HOST = "smtp.qq.com"; // QQ邮箱SMTP服务器
    private static final String SMTP_PORT = "587";
    private static final String FROM_EMAIL = "2741447135@qq.com"; // 发件人邮箱
    private static final String FROM_PASSWORD = "ozfxcdjldxcadfja"; // 授权码

    // 发送发货通知邮件
    public static boolean sendShippingNotification(String toEmail) {
        String subject = "您的订单已发货 - OnlineShop";
        String content = buildShippingNotificationContent();

        return sendEmail(toEmail, subject, content);
    }

    //构建邮件内容
    private static String buildShippingNotificationContent() {
        return """
        <html>
        <body>
            <h2>订单发货通知</h2>
            <p>尊敬的用户：</p>
            <p>您的订单已经发货，请注意查收。</p>
            <p>感谢您对 OnlineShop 的支持！</p>
        </body>
        </html>
        """;
    }

    //邮件发送
    private static boolean sendEmail(String toEmail, String subject, String content) {

        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.starttls.required", "true");
        props.put("mail.smtp.ssl.trust", "smtp.qq.com");
        props.put("mail.smtp.host", "smtp.qq.com");
        props.put("mail.smtp.port", "587");
        props.put("mail.smtp.connectiontimeout", "10000");
        props.put("mail.smtp.timeout", "10000");
        props.put("mail.smtp.writetimeout", "10000");


        Session session = Session.getInstance(props,
                new Authenticator() {
                    protected PasswordAuthentication getPasswordAuthentication() {
                        return new PasswordAuthentication(FROM_EMAIL, FROM_PASSWORD);
                    }
                });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(FROM_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject(subject);
            message.setContent(content, "text/html; charset=utf-8");

            Transport.send(message);

            logger.info("邮件发送成功: to=" + toEmail + ", subject=" + subject);
            return true;

        } catch (MessagingException e) {
            logger.severe("邮件发送失败: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
