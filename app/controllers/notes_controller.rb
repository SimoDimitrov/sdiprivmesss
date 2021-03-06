class NotesController < ApplicationController
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  # GET /notes
  # GET /notes.json
  def index
    @notes = Note.all
  end

  # GET /notes/1
  # GET /notes/1.json
  def show
    @note=Note.find_by slug:params[:slug]
    p params[:slug]
    @note.destroy
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  # POST /notes.json
  def create
    if request.content_type =~ /xml/
      params[:message] = Hash.from_xml(request.body.read)["message"]
      note = Note.create(content: params[:message])
      render xml:
      '<?xml version = "1.0" encoding = "UTF-8" standalone = "yes"?>' +
      '<url>' +
        notes_url + '/' + note.slug +  
      '</url>'
    elsif request.content_type =~ /json/
      note = Note.create(content: params[:message])
      render json: {url: notes_url + "/" + note.slug }
    elsif request.content_type =~ /form/
      @note = Note.new({content: params[:note][:content]})
      p @note
      if @note.save
        redirect_to notes_url + "/" + @note.slug  + '/info'
      else
        render 'index'
      end
    end
  end

  def info
    render "info", locals: {url: notes_url + "/" + params[:slug]}
  end

  # PATCH/PUT /notes/1
  # PATCH/PUT /notes/1.json
  def update
    respond_to do |format|
      if @note.update(note_params)
        format.html { redirect_to @note, notice: 'Note was successfully updated.' }
        format.json { render :show, status: :ok, location: @note }
      else
        format.html { render :edit }
        format.json { render json: @note.errors, status: :unprocessable_entity }
      end
    end
  end
  


  # DELETE /notes/1
  # DELETE /notes/1.json
  def destroy
    @note.destroy
    respond_to do |format|
      format.html { redirect_to notes_url, notice: 'Note was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find_by slug:params[:slug]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def note_params
      params.require(:note).permit(:content)
    end
end
