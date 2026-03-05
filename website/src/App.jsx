import { useState, useCallback } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Features from './components/Features';
import Architecture from './components/Architecture';
import AppPreview from './components/AppPreview';
import ContactForm from './components/ContactForm';
import Footer from './components/Footer';
import SplashScreen from './components/SplashScreen';

export default function App() {
  const [ready, setReady] = useState(false);
  const handleDone = useCallback(() => setReady(true), []);

  return (
    <div className="min-h-screen bg-background text-foreground">
      {/* Splash shown until all images are loaded */}
      {!ready && <SplashScreen onDone={handleDone} />}

      {/* Main site — rendered in DOM immediately for performance,
          but visually hidden until splash fades out */}
      <div className={`transition-opacity duration-500 ${ready ? 'opacity-100' : 'opacity-0'}`}>
        <Navbar />
        <main>
          <Hero />
          <Features />
          <Architecture />
          <AppPreview />
          <ContactForm />
        </main>
        <Footer />
      </div>
    </div>
  );
}
