function h=plotsurf(x, y, z,tit)
        h=imagesc(x, y, z);
        set(gca,'YDir','normal');
        view(2);
        shading flat;
        colormap(LabCmap('bluegreenyellow'));
        colorbar;
        %caxis([(maxz-abs(minz))/2-abs(minz)/2/caxisdiv(1),(maxz-abs(minz))/2+abs(minz)/2/caxisdiv(1)]);
        xlabel(tit);
        ylabel('Frequency (GHz)');
        title(strrep(tit,'_',' '));
    end