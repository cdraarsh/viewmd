cask "viewmd" do
  version "1.0.0"
  sha256 "5d5b0438e17709af0f843369fa06430725e35c3af88c255f71b8dd1739c4c1e7"

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
