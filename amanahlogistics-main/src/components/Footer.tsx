import { Facebook, Twitter, Instagram, Linkedin, Mail, Phone, MapPin } from "lucide-react";

const Footer = () => {
  return (
    <footer className="bg-background border-t border-border">
      <div className="container mx-auto px-4 py-12">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
          {/* Company Info */}
          <div className="space-y-4">
            <img 
              src="/lovable-uploads/445e8906-7b2d-479e-8e44-99a9332e70d9.png" 
              alt="Amanah" 
              className="h-8 w-auto"
            />
            <p className="text-muted-foreground text-sm">
              Local delivery management for your businesses.<br />
              Built for speed, control, and customer satisfaction
            </p>
          </div>

          {/* Quick Links */}
          <div className="space-y-4">
            <h4 className="text-md font-medium text-foreground">Quick Links</h4>
            <ul className="space-y-2">
              <li><a href="#features" className="text-muted-foreground hover:text-primary transition-colors text-sm">Features</a></li>
              <li><a href="#faq" className="text-muted-foreground hover:text-primary transition-colors text-sm">FAQ</a></li>
              <li><a href="https://form.typeform.com/to/mNUPuF4g" target="_blank" rel="noopener noreferrer" className="text-muted-foreground hover:text-primary transition-colors text-sm">Contact</a></li>
            </ul>
          </div>

          {/* Support */}
          <div className="space-y-4">
            <h4 className="text-md font-medium text-foreground">Support</h4>
            <ul className="space-y-2">
              <li><a href="#" className="text-muted-foreground hover:text-primary transition-colors text-sm">Help Center</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-primary transition-colors text-sm">Privacy Policy</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-primary transition-colors text-sm">Terms of Service</a></li>
              <li><a href="#" className="text-muted-foreground hover:text-primary transition-colors text-sm">Safety Guidelines</a></li>
            </ul>
          </div>

          {/* Contact Info */}
          <div className="space-y-4">
            <h4 className="text-md font-medium text-foreground">Contact Info</h4>
            <div className="space-y-3">
              <div className="flex items-center space-x-2">
                <Mail size={16} className="text-muted-foreground" />
                <span className="text-muted-foreground text-sm">amanahmvp@gmail.com</span>
              </div>
              <div className="flex items-center space-x-2">
                <Phone size={16} className="text-muted-foreground" />
                <span className="text-muted-foreground text-sm">+254 11 6087974</span>
              </div>
              <div className="flex items-center space-x-2">
                <MapPin size={16} className="text-muted-foreground" />
                <span className="text-muted-foreground text-sm">Mombasa, Kenya</span>
              </div>
            </div>
          </div>
        </div>

        {/* Bottom Bar */}
        <div className="border-t border-border mt-8 pt-6">
          <div className="flex flex-col md:flex-row justify-between items-center">
            <p className="text-muted-foreground text-sm">
              © 2025 Amanahlogistics. All rights reserved.
            </p>
            <div className="flex space-x-6 mt-4 md:mt-0">
              <a href="#" className="text-muted-foreground hover:text-primary transition-colors text-sm">Privacy</a>
              <a href="#" className="text-muted-foreground hover:text-primary transition-colors text-sm">Terms</a>
              <a href="#" className="text-muted-foreground hover:text-primary transition-colors text-sm">Cookies</a>
            </div>
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer;