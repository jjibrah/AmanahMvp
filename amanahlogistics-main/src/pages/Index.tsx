
import Navigation from "../components/Navigation";
import HeroSection from "../components/HeroSection";
import Footer from "../components/Footer";
import LargeTextSection from "../components/LargeTextSection";
import FeatureCardsSection from "../components/FeatureCardsSection";
import RiderAllySection from "../components/RiderAllySection";
import FAQSection from "../components/FAQSection";
import CTASection from "../components/CTASection";

const Index = () => {
  return (
    <div className="w-full">
      <Navigation />
      <HeroSection />
      
      <LargeTextSection />
      <FeatureCardsSection />
      <RiderAllySection />
      <FAQSection />
      <CTASection />
      <Footer />
    </div>
  );
};

export default Index;
