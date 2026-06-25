import type { Metadata } from "next";
import "./globals.css";
import { HtmlLangSetter } from "./html-lang-setter";

export const metadata: Metadata = {
  title: "Bear Adventure",
  description: "Bear Adventure Landing Page",
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <HtmlLangSetter />
        {children}
      </body>
    </html>
  );
}
