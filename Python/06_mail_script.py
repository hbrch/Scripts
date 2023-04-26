# Created 02.07.2021
# Simple template for a Mail script
import smtplib
import os
import pandas as pd
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email.mime.text import MIMEText
from email import encoders

mail_from = os.environ.get('EMAIL_USER')
mail_to = os.environ.get('EMAIL_LIST')
mail_pass = os.environ.get('EMAIL_PASS')

# Setting up the SMTP Server
# Example: googlemail.com
server = smtplib.SMTP('smtp.gmail.com', 587)
server.starttls()
server.login(mail_from, mail_pass)

# Creatinga Message Object
msg = MIMEMultipart()

# Composing the Mail
msg['From'] = mail_from
msg['To'] = mail_to
msg['Subject'] = 'Subject here'

body = 'Body here'
msg.attach(MIMEText(body, 'plain'))

# Adding a file to the Mail
# Example: .csv file
filename = 'file.csv'
filepath = os.path.join(os.getcwd(), filename)
attachment = open(filepath, 'rb')
part = MIMEBase('application', 'octet-stream')
part.set_payload((attachment).read())
encoders.encode_base64(part)
part.add_header('Content-Disposition', 'attachment', filename=filename)
msg.attach(part)

# Sending the mail
server.sendmail(msg['From'], msg['To'], msg.as_string())

# Closing the Server Connection
server.quit()
