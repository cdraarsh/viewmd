cask "viewmd" do
  version "1.0.0"
  sha256 "c7418fc9d7e7f547e6ab2ff3e6155141d9cbe62aca60dc21e1e536d5fd9d4c5d"

  url "https://github.com/cdraarsh/viewmd/releases/download/v#{version}/ViewMD-#{version}-mac-universal-unsigned.zip"
  name "ViewMD"
  desc "AI Markdown reader for Mac that exports local Markdown files to PDFs"
  homepage "https://github.com/cdraarsh/viewmd"

  depends_on macos: ">= :ventura"

  app "ViewMD.app"

  zap trash: [
    "~/Library/Preferences/com.viewmd.app.plist",
    "~/Library/Saved Application State/com.viewmd.app.savedState",
  ]
end
