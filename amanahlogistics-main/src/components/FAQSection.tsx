
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { Button } from "@/components/ui/button";

const faqItems = [
  {
    question: "How quickly can I set up Amanah?",
    answer: "You can set up Amanah in minutes. Just register, add your riders, and start dispatching right away."
  },
  {
    question: "Can I use my own riders with Amanah?",
    answer: "Absolutely! Amanah allows you to manage your own fleet or tap into our network of verified riders."
  },
  {
    question: "Is Amanah suitable for businesses of all sizes?",
    answer: "Absolutely! Whether you're running a small fleet or you are a large courier enterprise, Amanah is built to scale seamlessly with your business."
  },
  {
    question: "Can Amanah handle multiple deliveries simultaneously?",
    answer: "Yes, Amanah effortlessly manages multiple deliveries at once, automatically optimizing routes and assignments to ensure peak efficiency."
  },
  {
    question: "Do I need special hardware to use Amanah?",
    answer: "No special hardware needed! Amanah is cloud-based and works perfectly on smartphones, tablets, and desktop computers, making it simple to integrate into your current operations."
  }
];

const FAQSection = () => {
  return (
    <div id="faq" className="w-full px-4 md:px-8 lg:px-16 py-16 md:py-20 lg:py-28 bg-white overflow-hidden flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
      <div className="w-full max-w-[1280px] flex flex-col justify-start items-center gap-12 md:gap-16 lg:gap-20">
        <div className="w-full max-w-[768px] flex flex-col justify-start items-center gap-6">
          <div className="w-full text-center text-[#004746] text-3xl md:text-5xl lg:text-6xl font-poppins font-medium capitalize leading-tight lg:leading-[66px]">
            need help?
          </div>
          <div className="w-full text-center text-black text-sm md:text-base font-inter font-normal leading-5 md:leading-6">
            Whether you're a small startup, a growing mid-sized business, or a large enterprise, we're here to make things simple and support you at every step.
          </div>
        </div>
        
        <div className="w-full max-w-[768px]">
          <Accordion type="single" collapsible className="w-full">
            {faqItems.map((item, index) => (
              <AccordionItem key={index} value={`item-${index}`} className="border-b border-black">
                <AccordionTrigger className="text-left py-5 hover:no-underline">
                  <div className="text-black text-lg font-poppins font-semibold leading-[21.6px]">
                    {item.question}
                  </div>
                </AccordionTrigger>
                <AccordionContent className="pb-6">
                  <div className="text-black text-base font-inter font-normal leading-6 max-w-[768px]">
                    {item.answer}
                  </div>
                </AccordionContent>
              </AccordionItem>
            ))}
          </Accordion>
        </div>

        <div className="w-full max-w-[560px] flex flex-col justify-start items-center gap-6">
          <div className="w-full flex flex-col justify-start items-center gap-4">
            <div className="w-full text-center text-[#004746] text-2xl md:text-3xl font-roboto font-bold leading-tight md:leading-[41.6px]">
              Still have questions?
            </div>
            <div className="w-full text-center text-black text-sm md:text-base font-inter font-normal leading-5 md:leading-6">
              We are always open to answer any question
            </div>
          </div>
          <div className="flex justify-center items-center">
            <Button 
              asChild
              variant="outline" 
              className="px-6 py-3 border border-[#004746] text-[#004746] font-poppins font-medium hover:bg-[#004746] hover:text-white rounded-xl"
            >
              <a href="https://form.typeform.com/to/mNUPuF4g" target="_blank" rel="noopener noreferrer">
                Contact us
              </a>
            </Button>
          </div>
        </div>
      </div>
    </div>
  );
};

export default FAQSection;
