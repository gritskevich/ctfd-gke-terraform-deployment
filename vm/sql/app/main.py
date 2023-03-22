import webapp2 as webapp
import webapp2_static
import os
import jinja2
import sqlite3

def render(tpl_path, context={}):
	path, filename = os.path.split(tpl_path)
	return jinja2.Environment(loader=jinja2.FileSystemLoader(path or './')).get_template(filename).render(context)


class LoginPage(webapp.RequestHandler):

	def get(self):
		message = ""
		if self.request.get("username") is not None and len(self.request.get("username")) > 1:

			c = sqlite3.connect('db.db')
			req = "SELECT username, password FROM account WHERE username='%s' AND password='%s'" % (self.request.get("username"), self.request.get("password"))
			for row in c.execute(req):
				self.response.out.write(render('guest.html') % ("admin", "flag is PLOP"))
				return

		if self.request.get("username") is not None and len(self.request.get("username")) > 1:
			message = "Wrong Username or Password"
		self.response.out.write(render('index.html') % message)


application = webapp.WSGIApplication([(r'/', LoginPage), (r'/index.php', LoginPage), (r'/static/(.+)', webapp2_static.StaticFileHandler)], config={'webapp2_static.static_file_path': './static'})


def main():
	from paste import httpserver
	httpserver.serve(application, host='0.0.0.0', port='80')


if __name__ == '__main__':
	main()
