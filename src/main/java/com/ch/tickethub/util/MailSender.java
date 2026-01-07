package com.ch.tickethub.util;

import java.util.Properties;

import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.stereotype.Component;
import com.ch.tickethub.exception.EmailException;

import lombok.extern.slf4j.Slf4j;

@Component
@Slf4j
public class MailSender {
	String host = "smtp.gmail.com";
	String user = "namyeowon01@gmail.com"; // 보내는 자
	String password;
	Properties props = new Properties();
	
	private String emailPassword;
	
	public MailSender(@Qualifier("emailPassword") String emailPassword) {
		password = emailPassword;
	}
	
	public void send(String to, String title, String content ) {
		log.debug("앱비밀번호 가져옴...");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", 465);
		props.put("mail.smtp.auth", "true");
		props.put("mail.smtp.ssl.enable", "true");
		//props.put("mail.smtp.ssl.trust", "smtp.gmail.com");
		props.put("mail.smtp.ssl.protocols", "TLSv1.2");  // TLS 버전 강제

		Session session = Session.getDefaultInstance(props, new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
	               return new PasswordAuthentication(user, password);
	            }	
		});
		
		try {
			
			MimeMessage message = new MimeMessage(session);
			message.setFrom(new InternetAddress(user));
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(to));
			message.setSubject(title);
			message.setContent(content, "text/html;charset=utf-8");
			
			Transport.send(message);
			
		} catch (MessagingException e) {
			e.printStackTrace();
			throw new EmailException("이메일 발송 실패", e);
		}
	}
}
