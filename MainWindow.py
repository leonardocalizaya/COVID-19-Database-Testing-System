import sys
from PyQt5.QtWidgets import (QApplication, QWidget, QPushButton,
    QHBoxLayout, QVBoxLayout, QLineEdit, QApplication, QLabel, QRadioButton, QPushButton)

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("COVID-19 Testing System")

        vbox = QVBoxLayout()
        hbox1 = QHBoxLayout()
        hbox2 = QHBoxLayout()
        hbox3 = QHBoxLayout()


        # HBOX 1

        username = QLabel("Username:", self)
        self.username_entry = QLineEdit()

        hbox1.addWidget(username)
        hbox1.addWidget(self.username_entry)

        # HBOX 2

        password = QLabel("Password:", self)
        self.password_entry = QLineEdit()
        self.password_entry.setEchoMode(QLineEdit.Password)

        hbox2.addWidget(password)
        hbox2.addWidget(self.password_entry)

        # HBOX 3

        self.login_button = QPushButton("Login")
        self.register_button = QPushButton("Register")

        hbox3.addWidget(self.login_button)
        hbox3.addWidget(self.register_button)

        ## Links

        switch_login = QtCore.pyqtSignal()
        switch_login.connect()



        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)
        vbox.addLayout(hbox3)
        self.setLayout(vbox)


class StudentHome(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Student Home")

        vbox = QVBoxLayout()
        hbox1 = QHBoxLayout()
        hbox2 = QHBoxLayout()


        # HBOX 1

        viewresults = QPushButton("View My Results")
        viewaggregateresults = QPushButton("View Aggregate Results")

        hbox1.addWidget(viewresults)
        hbox1.addWidget(viewaggregateresults)

        # HBOX 2

        signuptest = QPushButton("Sign Up for a Test")
        dailyresults = QPushButton("View Daily Results")

        hbox2.addWidget(signuptest)
        hbox2.addWidget(dailyresults)


        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)
        self.setLayout(vbox)


class Register(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Registration")

        hbox = QHBoxLayout()

        vbox1 = QVBoxLayout()
        vbox2 = QVBoxLayout()


        # HBOX 1

        username = QLabel("Username:", self)
        self.username_entry = QLineEdit()

        email = QLabel("Email:", self)
        self.email_entry = QLineEdit()

        vbox1.addWidget(username)
        vbox1.addWidget(self.username_entry)

        vbox2.addWidget(email)
        vbox2.addWidget(self.email_entry)

        # HBOX 2

        firstname = QLabel("First Name:", self)
        self.firstname_entry = QLineEdit()

        lastname = QLabel("Last Name:", self)
        self.lastname_entry = QLineEdit()

        vbox1.addWidget(firstname)
        vbox1.addWidget(self.firstname_entry)

        vbox2.addWidget(lastname)
        vbox2.addWidget(self.lastname_entry)

        # HBOX 3

        password = QLabel("Password:", self)
        self.password_entry = QLineEdit()
        self.password_entry.setEchoMode(QLineEdit.Password)

        cpassword = QLabel("Confirm Password:", self)
        self.cpassword_entry = QLineEdit()
        self.cpassword_entry.setEchoMode(QLineEdit.Password)

        vbox1.addWidget(password)
        vbox1.addWidget(self.password_entry)

        vbox2.addWidget(cpassword)
        vbox2.addWidget(self.cpassword_entry)

        #HBOX 6

        self.login_button = QPushButton("Back to Login")
        self.register_button = QPushButton("Register")

        vbox1.addWidget(self.login_button)
        vbox2.addWidget(self.register_button)

        ## Links




        hbox.addLayout(vbox1)
        hbox.addLayout(vbox2)
        self.setLayout(hbox)



class Controller:

    def __init__(self):
        pass



if __name__ == '__main__':
    app = QApplication(sys.argv)
    main = Register()
    main.show()
    sys.exit(app.exec())

