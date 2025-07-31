import { useState } from "react";
import { Menu, X } from "lucide-react";

const Navigation = () => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);

  const toggleMenu = () => {
    setIsMenuOpen(!isMenuOpen);
  };

  return (
    <nav className="w-full bg-white border-b border-gray-200 sticky top-0 z-50">
      <div className="w-full max-w-[1280px] mx-auto px-4 md:px-8 lg:px-16">
        <div className="flex justify-between items-center h-16 md:h-20">
          {/* Logo */}
          <div className="flex items-center">
            <img 
              src="/lovable-uploads/445e8906-7b2d-479e-8e44-99a9332e70d9.png" 
              alt="Amanah" 
              className="h-8 md:h-10 w-auto"
            />
          </div>

          {/* Desktop Navigation */}
          <div className="hidden md:flex items-center space-x-8">
            <a href="#features" className="text-black text-sm font-inter font-medium hover:text-[#004746] transition-colors">
              Features
            </a>
            <a href="#pricing" className="text-black text-sm font-inter font-medium hover:text-[#004746] transition-colors">
              Pricing
            </a>
            <a href="https://form.typeform.com/to/mNUPuF4g" target="_blank" rel="noopener noreferrer" className="text-black text-sm font-inter font-medium hover:text-[#004746] transition-colors">
              Contact
            </a>
          </div>

          {/* Desktop CTA Buttons */}
          <div className="hidden md:flex items-center">
            <a 
              href="https://form.typeform.com/to/mNUPuF4g" 
              target="_blank" 
              rel="noopener noreferrer"
              className="px-4 py-2 bg-[#004746] text-white text-sm font-poppins font-medium rounded-lg hover:bg-[#003635] transition-colors"
            >
              Get Started
            </a>
          </div>

          {/* Mobile Menu Button */}
          <button
            onClick={toggleMenu}
            className="md:hidden p-2 text-[#004746] hover:bg-gray-50 rounded-lg transition-colors"
          >
            {isMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>

        {/* Mobile Menu */}
        {isMenuOpen && (
          <div className="md:hidden absolute left-0 right-0 top-full bg-white border-b border-gray-200 shadow-lg">
            <div className="px-4 py-6 space-y-4">
              <a href="#features" className="block text-black text-base font-inter font-medium hover:text-[#004746] transition-colors py-2">
                Features
              </a>
              <a href="#pricing" className="block text-black text-base font-inter font-medium hover:text-[#004746] transition-colors py-2">
                Pricing
              </a>
              <a href="https://form.typeform.com/to/mNUPuF4g" target="_blank" rel="noopener noreferrer" className="block text-black text-base font-inter font-medium hover:text-[#004746] transition-colors py-2">
                Contact
              </a>
              <div className="pt-4 border-t border-gray-200">
                <a 
                  href="https://form.typeform.com/to/mNUPuF4g" 
                  target="_blank" 
                  rel="noopener noreferrer"
                  className="block w-full px-4 py-2 bg-[#004746] text-white text-sm font-poppins font-medium rounded-lg hover:bg-[#003635] transition-colors text-center"
                >
                  Get Started
                </a>
              </div>
            </div>
          </div>
        )}
      </div>
    </nav>
  );
};

export default Navigation;