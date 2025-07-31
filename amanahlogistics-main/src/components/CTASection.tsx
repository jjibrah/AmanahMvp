
import { Button } from "@/components/ui/button";

const CTASection = () => {
  return (
    <div className="w-full px-4 md:px-8 lg:px-16 py-16 md:py-20 lg:py-28 bg-white overflow-hidden flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
      <div className="w-full max-w-[1280px] flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
        <div className="w-full max-w-[768px] flex flex-col justify-start items-center gap-8">
          <div className="w-full flex flex-col justify-start items-center gap-6">
            <div className="flex flex-col justify-start items-center">
              <div className="w-full text-center text-[#004746] text-3xl md:text-5xl lg:text-6xl font-poppins font-medium capitalize leading-tight lg:leading-[66px]">
                Transform your deliveries
              </div>
              <div className="w-full text-center text-[#004746] text-3xl md:text-5xl lg:text-6xl font-poppins font-medium capitalize leading-tight lg:leading-[66px]">
                today !
              </div>
            </div>
            <div className="w-full text-center text-black text-sm md:text-base font-inter font-normal leading-5 md:leading-6">
              Join other forward-thinking courier businesses revolutionizing their deliveries with Amanah.
            </div>
          </div>
          <div className="flex justify-start items-start gap-4">
            <Button 
              asChild
              className="px-6 py-3 bg-[#004746] text-white font-poppins font-medium hover:bg-[#004746]/90 rounded-xl"
            >
              <a href="https://form.typeform.com/to/mNUPuF4g" target="_blank" rel="noopener noreferrer">
                Secure early access now
              </a>
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default CTASection;
