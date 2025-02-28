package com.SE.service;

import java.util.Properties;
import javax.mail.*;
import javax.mail.internet.*;

import org.springframework.stereotype.Service;
import com.SE.entity.UserEntity;

@Service
public class MailerService {

    private final String FROM_EMAIL = "market.mindss23@gmail.com";
    private final String APP_PASSWORD = "myhrwiyyyeoetepg";
    private final Properties mailProperties;

    public MailerService() {
        mailProperties = new Properties();
        mailProperties.put("mail.smtp.auth", "true");
        mailProperties.put("mail.smtp.starttls.enable", "true");
        mailProperties.put("mail.smtp.host", "smtp.gmail.com");
        mailProperties.put("mail.smtp.port", "587");
    }

    private Session getSession() {
        return Session.getInstance(mailProperties, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(FROM_EMAIL, APP_PASSWORD);
            }
        });
    }

    private boolean sendEmail(String recipient, String subject, String content) {
        try {
            MimeMessage message = new MimeMessage(getSession());
            message.setFrom(FROM_EMAIL);
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
            message.setSubject(subject);
            message.setContent(content, "text/html");

            Transport.send(message);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean sendForgotPasswordOTP(UserEntity user) {
        String content = "Your OTP for password reset: <b>" + user.getOtp() + "</b>";
        return sendEmail(user.getEmail(), "Password Reset OTP", content);
    }

 
}
