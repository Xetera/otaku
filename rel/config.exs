use Mix.Releases.Config,
    default_release: :default,
    default_environment: Mix.env()

environment :prod do
  set include_erts: true
  set include_src: false
end

release :otaku do
  set applications: [
        :runtime_tools
      ]
end

